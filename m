From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 04/25] ACPI / APEI: Make hest.c manage the estatus
 memory pool
Date: Wed, 19 Dec 2018 15:42:34 +0100
Message-ID: <20181219144234.GA31643@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-5-james.morse@arm.com>
 <20181211164802.GI27375@zn.tnic>
 <ad48f9a1-404e-7878-3173-f8a4a417a723@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 058F44A321
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 09:42:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6yvWy+YNpWcc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 09:42:40 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B494F4A2F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 09:42:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <ad48f9a1-404e-7878-3173-f8a4a417a723@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 14, 2018 at 01:56:16PM +0000, James Morse wrote:
> /me digs a bit,
> 
> ghes_estatus_pool_init() allocates memory from hest_ghes_dev_register().
> Its caller is behind a 'if (!ghes_disable)' in acpi_hest_init(), and is after
> another 2 calls to apei_hest_parse().
> 
> If ghes_disable is set, we don't call this thing.
> If hest_disable is set, acpi_hest_init() exits early.
> If we don't have a HEST table, acpi_hest_init() exits early.
> 
> ... if the HEST table doesn't have any GHES entries, hest_ghes_dev_register() is
> called with ghes_count==0, and does nothing useful. (kmalloc_alloc_array(0,...)
> great!) But we do call ghes_estatus_pool_init().
> 
> I think a check that ghes_count is non-zero before calling
> hest_ghes_dev_register() is the cleanest way to avoid this.

Grrr, what an effing mess that code is! There's hest_disable *and*
ghes_disable. Do we really need them both?

With my simplifier hat on I wanna say, we should have a single switch -
apei_disable - and kill those other two. What a damn mess that is.

> I wanted the estatus pool to be initialised before creating the platform devices
> in case the order of these things is changed in the future and they get probed
> immediately, before the pool is initialised.

Hmmm.

Actually, I meant flipping those two calls:

        rc = ghes_estatus_pool_init(ghes_count);
        if (rc)
                goto out;

        rc = apei_hest_parse(hest_parse_ghes, &ghes_arr);
        if (rc)
                goto err;

to

        rc = apei_hest_parse(hest_parse_ghes, &ghes_arr);
        if (rc)
                goto err;

        rc = ghes_estatus_pool_init(ghes_count);
        if (rc)
                goto out;

so as not to alloc the pool unnecessarily if the parsing fails.

Also, AFAICT, the order you have them in now might be a problem anyway
if

	apei_hest_parse(hest_parse_ghes, &ghes_arr);

fails because then you goto err and and that pool leaks, right?

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
