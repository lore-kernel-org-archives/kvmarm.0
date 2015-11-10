From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 resend] ARM/arm64: KVM: test properly for a PTE's
 uncachedness
Date: Tue, 10 Nov 2015 15:16:03 +0100
Message-ID: <20151110141603.GF12968@cbox>
References: <1447164680-16330-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5E0496F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2015 09:15:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aDRYKEU6og2U for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2015 09:15:58 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4E9D496EC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2015 09:15:57 -0500 (EST)
Received: by wmec201 with SMTP id c201so135725071wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2015 06:16:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1447164680-16330-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 10, 2015 at 03:11:20PM +0100, Ard Biesheuvel wrote:
> The open coded tests for checking whether a PTE maps a page as
> uncached use a flawed '(pte_val(xxx) & CONST) != CONST' pattern,
> which is not guaranteed to work since the type of a mapping is
> not a set of mutually exclusive bits
> 
> For HYP mappings, the type is an index into the MAIR table (i.e, the
> index itself does not contain any information whatsoever about the
> type of the mapping), and for stage-2 mappings it is a bit field where
> normal memory and device types are defined as follows:
> 
>     #define MT_S2_NORMAL            0xf
>     #define MT_S2_DEVICE_nGnRE      0x1
> 
> I.e., masking *and* comparing with the latter matches on the former,
> and we have been getting lucky merely because the S2 device mappings
> also have the PTE_UXN bit set, or we would misidentify memory mappings
> as device mappings.
> 
> Since the unmap_range() code path (which contains one instance of the
> flawed test) is used both for HYP mappings and stage-2 mappings, and
> considering the difference between the two, it is non-trivial to fix
> this by rewriting the tests in place, as it would involve passing
> down the type of mapping through all the functions.
> 
> However, since HYP mappings and stage-2 mappings both deal with host
> physical addresses, we can simply check whether the mapping is backed
> by memory that is managed by the host kernel, and only perform the
> D-cache maintenance if this is the case.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Tested-by: Pavel Fedin <p.fedin@samsung.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks, applied.

-Christoffer
