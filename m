From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 5/8] KVM: arm/arm64: Enforce PTE mappings at stage2 when
 needed
Date: Tue, 2 Apr 2019 12:07:28 +0200
Message-ID: <fd6fb49e-5f46-1f0c-c849-f328c7540059@redhat.com>
References: <20190328133608.110805-1-marc.zyngier@arm.com>
 <20190328133608.110805-6-marc.zyngier@arm.com>
 <496ad70d-eaa5-c46e-ddf0-d07607522eeb@redhat.com>
 <20190402094716.GA1082@en101>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190402094716.GA1082@en101>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Julien Thierry <julien.thierry@arm.com>, YueHaibing <yuehaibing@huawei.com>, Zheng Xiang <zhengxiang9@huawei.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, Nianyao Tang <tangnianyao@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 4/2/19 11:47 AM, Suzuki K Poulose wrote:
> On Mon, Apr 01, 2019 at 07:10:37PM +0200, Auger Eric wrote:
>> Hi Suzuki,
>>
>> On 3/28/19 2:36 PM, Marc Zyngier wrote:
>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> commit 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
>>> made the checks to skip huge mappings, stricter. However it introduced
>>> a bug where we still use huge mappings, ignoring the flag to
>>> use PTE mappings, by not reseting the vma_pagesize to PAGE_SIZE.
>>>
>>> Also, the checks do not cover the PUD huge pages, that was
>>> under review during the same period. This patch fixes both
>>> the issues.
>>
>> I face a regression with this patch. My guest gets stuck. I am running
>> on AMD Seattle. Reverting the patch makes things work again for me. I
>> run with qemu. In this scenario I don't use hugepages. I use 64kB page
>> size for both the host and guest.
> 
> Hi Eric,
> 
> Thanks for the testing. Does the following patch fix the issue for you ?

Yes it does.

Thanks

Eric
> 
> 
> ---8>---
> kvm: arm: Skip transparent huge pages in unaligned memslots
> 
> We silently create stage2 huge mappings for a memslot with
> unaligned IPA and user address.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 27c9583..4a22f5b 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1412,7 +1412,9 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
>  		 * page accordingly.
>  		 */
>  		mask = PTRS_PER_PMD - 1;
> -		VM_BUG_ON((gfn & mask) != (pfn & mask));
> +		/* Skip memslots with unaligned IPA and user address */
> +		if ((gfn & mask) != (pfn & mask))
> +			return false;
>  		if (pfn & mask) {
>  			*ipap &= PMD_MASK;
>  			kvm_release_pfn_clean(pfn);
> 
