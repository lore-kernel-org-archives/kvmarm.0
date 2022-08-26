Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BE4ECAAA3
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 01:29:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1643C4E45F;
	Thu, 25 Aug 2022 21:29:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H0KUuR91YJeI; Thu, 25 Aug 2022 21:29:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1B094E462;
	Thu, 25 Aug 2022 21:29:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7B3F4E45D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 21:29:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 40nYjuGBo3tO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 21:29:50 -0400 (EDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com
 [209.85.217.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D95A4E45C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 21:29:50 -0400 (EDT)
Received: by mail-vs1-f46.google.com with SMTP id o123so356519vsc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 18:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=2ekbr1AY/0ro4MNsPt6q1bT/kwZa5YwXe1eeOkdzbj0=;
 b=iJzbBaWobA+v3Fls9FBR9ulJyS7gOTa+okT0Roe5/N6j2Bx1N2gDa6soWJJPYFB6Gn
 aZwQDFZEQ2UM68o7CDyooH2S5Fz+O0zTMNpOc0LA1KKRK8z5OxwjFAiMg8MobnmQFVUk
 nUboIue5892TXpYUzj2DYfN3eKyvTbpEOXIllxEXOCUuskKt1da3tEPU4U/Jim6sVp8Z
 DmkPRjIGd9dHEPIrzJyAuD2bWoR4gpO5nPj5LkPD2WDrgyORNdLp9L/OZ2V/zGZfcHdy
 rUy92i2aKowkYOSLF3s3jBfv1MIX9U+WHBQOPgjFcXUYZrgtaCL0UMClF/MWLnIVs9TG
 j8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=2ekbr1AY/0ro4MNsPt6q1bT/kwZa5YwXe1eeOkdzbj0=;
 b=8I6VsG+a5k1dDtH+dvKcKYXeGmzkYa5d6TaB9P34qxS1PjWScu02IN7GJP5BaLXLDQ
 p6R/VzdN5/NOh3vG7R3Aw6+BEyhmsxIP3tkYQ1rjTolxx6KoZV0/iQvskq0F/LBAHbAE
 iFdMS9WLHl+v1F2xAGkp0R8AdbIgLlOv2CpXseSXUh0Q4RYVfaivEwsZ9fYKqFOFz19o
 BIjGgr4jWTSR7XqIr2O4Eom2x5cW85Dxkr5Ugq/mtWE3YEsshH+/fUl+3I2PI4TBAICr
 YVd8kovge1ZgLYE1c3S45MLKUBSYIDToI+sWMlDBXmzQQo+2M8BY/XgkSpzNajRaykQP
 Aysg==
X-Gm-Message-State: ACgBeo0KsL/kLu3o1mqDvhkf3orzlDR0gWPgB0xt1KWh3pLa87HPtud9
 pDyA1mdbxBx4Rx/eDCs4ZxMZZdSK7QT+qs2dfwMntQ==
X-Google-Smtp-Source: AA6agR6j2m3pmhhwkF7FdZcEb6pXGIIfBXTP7oUuiKmKJ3N+tfbsKBjRFCuYLuBTifiWUHMFhO1pQNsYSmty1yTeE0s=
X-Received: by 2002:a67:de11:0:b0:390:4ef6:6a5f with SMTP id
 q17-20020a67de11000000b003904ef66a5fmr2605311vsk.58.1661477390064; Thu, 25
 Aug 2022 18:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-8-reijiw@google.com>
In-Reply-To: <20220825050846.3418868-8-reijiw@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 25 Aug 2022 18:29:34 -0700
Message-ID: <CAAeT=FxJLykbrgKSC6DNFr+hWr-=TOq60ODFZ7r+jGOV3a=KWg@mail.gmail.com>
Subject: Re: [PATCH 7/9] KVM: arm64: selftests: Add a test case for a linked
 breakpoint
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Aug 24, 2022 at 10:10 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Currently, the debug-exceptions test doesn't have a test case for
> a linked breakpoint. Add a test case for the linked breakpoint to
> the test.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 59 +++++++++++++++++--
>  1 file changed, 55 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index ab8860e3a9fa..9fccfeebccd3 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -11,6 +11,10 @@
>  #define DBGBCR_EXEC    (0x0 << 3)
>  #define DBGBCR_EL1     (0x1 << 1)
>  #define DBGBCR_E       (0x1 << 0)
> +#define DBGBCR_LBN_SHIFT       16
> +#define DBGBCR_BT_SHIFT                20
> +#define DBGBCR_BT_ADDR_LINK_CTX        (0x1 << DBGBCR_BT_SHIFT)
> +#define DBGBCR_BT_CTX_LINK     (0x3 << DBGBCR_BT_SHIFT)
>
>  #define DBGWCR_LEN8    (0xff << 5)
>  #define DBGWCR_RD      (0x1 << 3)
> @@ -21,7 +25,7 @@
>  #define SPSR_D         (1 << 9)
>  #define SPSR_SS                (1 << 21)
>
> -extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
> +extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
>  static volatile uint64_t sw_bp_addr, hw_bp_addr;
>  static volatile uint64_t wp_addr, wp_data_addr;
>  static volatile uint64_t svc_addr;
> @@ -103,6 +107,7 @@ static void reset_debug_state(void)
>         isb();
>
>         write_sysreg(0, mdscr_el1);
> +       write_sysreg(0, contextidr_el1);
>
>         /* Reset all bcr/bvr/wcr/wvr registers */
>         dfr0 = read_sysreg(id_aa64dfr0_el1);
> @@ -164,6 +169,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
>         enable_debug_bwp_exception();
>  }
>
> +void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
> +                      uint64_t ctx)
> +{
> +       uint32_t addr_bcr, ctx_bcr;
> +
> +       /* Setup a context-aware breakpoint */
> +       ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> +                 DBGBCR_BT_CTX_LINK;
> +       write_dbgbcr(ctx_bp, ctx_bcr);
> +       write_dbgbvr(ctx_bp, ctx);
> +
> +       /* Setup a linked breakpoint (linked to the context-aware breakpoint) */
> +       addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> +                  DBGBCR_BT_ADDR_LINK_CTX |
> +                  ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);
> +       write_dbgbcr(addr_bp, addr_bcr);
> +       write_dbgbvr(addr_bp, addr);
> +       isb();
> +
> +       enable_debug_bwp_exception();
> +}
> +
>  static void install_ss(void)
>  {
>         uint32_t mdscr;
> @@ -177,8 +204,10 @@ static void install_ss(void)
>
>  static volatile char write_data;
>
> -static void guest_code(uint8_t bpn, uint8_t wpn)
> +static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
>  {
> +       uint64_t ctx = 0x1;     /* a random context number */
> +
>         GUEST_SYNC(0);
>
>         /* Software-breakpoint */
> @@ -281,6 +310,19 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
>                      : : : "x0");
>         GUEST_ASSERT_EQ(ss_addr[0], 0);
>

I've just noticed that I should add GUEST_SYNC(10) here, use
GUEST_SYNC(11) for the following test case, and update the
stage limit value in the loop in userspace code.

Or I might consider removing the stage management code itself.
It doesn't appear to be very useful to me, and I would think
we could easily forget to update it :-)

Thank you,
Reiji

> +       /* Linked hardware-breakpoint */
> +       hw_bp_addr = 0;
> +       reset_debug_state();
> +       install_hw_bp_ctx(bpn, ctx_bpn, PC(hw_bp_ctx), ctx);
> +       /* Set context id */
> +       write_sysreg(ctx, contextidr_el1);
> +       isb();
> +       asm volatile("hw_bp_ctx: nop");
> +       write_sysreg(0, contextidr_el1);
> +       GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
> +
> +       GUEST_SYNC(10);
> +
>         GUEST_DONE();
>  }
>
> @@ -327,6 +369,7 @@ int main(int argc, char *argv[])
>         struct ucall uc;
>         int stage;
>         uint64_t aa64dfr0;
> +       uint8_t brps;
>
>         vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>         ucall_init(vm, NULL);
> @@ -349,8 +392,16 @@ int main(int argc, char *argv[])
>         vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
>                                 ESR_EC_SVC64, guest_svc_handler);
>
> -       /* Run tests with breakpoint#0 and watchpoint#0. */
> -       vcpu_args_set(vcpu, 2, 0, 0);
> +       /* Number of breakpoints, minus 1 */
> +       brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
> +       __TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
> +
> +       /*
> +        * Run tests with breakpoint#0 and watchpoint#0, and the higiest
> +        * numbered (context-aware) breakpoint.
> +        */
> +       vcpu_args_set(vcpu, 3, 0, 0, brps);
> +
>         for (stage = 0; stage < 11; stage++) {
>                 vcpu_run(vcpu);
>
> --
> 2.37.1.595.g718a3a8f04-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
