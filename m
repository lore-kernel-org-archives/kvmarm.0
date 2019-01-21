From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 18/25] ACPI / APEI: Split ghes_read_estatus() to allow
 a peek at the CPER length
Date: Mon, 21 Jan 2019 14:53:04 +0100
Message-ID: <20190121135304.GI29166@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-19-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-19-james.morse@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 06:06:06PM +0000, James Morse wrote:
> ghes_read_estatus() reads the record address, then the record's
> header, then performs some sanity checks before reading the
> records into the provided estatus buffer.
> 
> To provide this estatus buffer the caller must know the size of the
> records in advance, or always provide a worst-case sized buffer as
> happens today for the non-NMI notifications.
> 
> Add a function to peek at the record's header to find the size. This
> will let the NMI path allocate the right amount of memory before reading
> the records, instead of using the worst-case size, and having to copy
> the records.
> 
> Split ghes_read_estatus() to create __ghes_peek_estatus() which
> returns the address and size of the CPER records.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> Changes since v6:
>  * Additional buf_addr = 0 error handling
>  * Moved checking out of peek-estatus
>  * Reworded an error message so we can tell them apart
> ---
>  drivers/acpi/apei/ghes.c | 59 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 47 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index b70f5fd962cc..07a12aac4c1a 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -277,12 +277,12 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
>  	}
>  }
>  
> -static int ghes_read_estatus(struct ghes *ghes,
> -			     struct acpi_hest_generic_status *estatus,
> -			     u64 *buf_paddr, int fixmap_idx)
> +/* Read the CPER block and returning its address, and header in estatus. */

s/and /,/

> +static int __ghes_peek_estatus(struct ghes *ghes, int fixmap_idx,
> +			       struct acpi_hest_generic_status *estatus,

Also, we probably should stick to some order of arguments of those
functions for easier code staring, i.e.

	function_name(ghes, estatus, buf_paddr, fixmap_idx)

or so.

> +			       u64 *buf_paddr)
>  {
>  	struct acpi_hest_generic *g = ghes->generic;
> -	u32 len;
>  	int rc;
>  
>  	rc = apei_read(buf_paddr, &g->error_status_address);
> @@ -303,29 +303,64 @@ static int ghes_read_estatus(struct ghes *ghes,
>  		return -ENOENT;
>  	}
>  
> -	rc = -EIO;
> -	len = cper_estatus_len(estatus);
> +	return 0;
> +}
> +
> +/* Check the top-level record header has an appropriate size. */
> +int __ghes_check_estatus(struct ghes *ghes,
> +			 struct acpi_hest_generic_status *estatus)
> +{
> +	u32 len = cper_estatus_len(estatus);
> +	int rc = -EIO;
> +
>  	if (len < sizeof(*estatus))
>  		goto err_read_block;
>  	if (len > ghes->generic->error_block_length)
>  		goto err_read_block;
>  	if (cper_estatus_check_header(estatus))
>  		goto err_read_block;

Please make this chunk more user-friendly, maybe in a separate patch ontop:

/* Check the top-level record header has an appropriate size. */
int __ghes_check_estatus(struct ghes *ghes,
                         struct acpi_hest_generic_status *estatus)
{
        u32 len = cper_estatus_len(estatus);

        if (len < sizeof(*estatus)) {
                pr_warn_ratelimited(FW_WARN GHES_PFX "Truncated error status block!\n");
                return -EIO;
        }

        if (len > ghes->generic->error_block_length) {
                pr_warn_ratelimited(FW_WARN GHES_PFX "Invalid error status block length!\n");
                return -EIO;
        }

        if (cper_estatus_check_header(estatus)) {
                pr_warn_ratelimited(FW_WARN GHES_PFX "Invalid CPER header!\n");
                return -EIO;
        }

        return 0;
}

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
