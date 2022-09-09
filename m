Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91F7ECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 20:18:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A9EA4C379;
	Fri,  9 Sep 2022 16:18:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 88l79h6aB1Pw; Fri,  9 Sep 2022 16:18:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6FE4C39C;
	Fri,  9 Sep 2022 16:18:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C6E64C37D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 16:18:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8XxIIvHo2QLX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 16:18:36 -0400 (EDT)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 193854C37C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 16:18:36 -0400 (EDT)
Received: by mail-pj1-f46.google.com with SMTP id pj10so2505427pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2022 13:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=Gy6Kb+oqE1M2CTgOLFPHiphkU8Pf6T4kljcQ0TYHTVU=;
 b=FDUnVkbH8U8f4VqkHeXTQz8VBGCAg9T1M86mp58PgbGJVxB/++bZ9ohGsUqgyORkEq
 sovW02zELW9agK7THxfH1n4B+/ipzCVHE/hcDEEbyNCDdlngwmx9R3sAfPiso+om99TA
 L11+aCvYwe1LcM/9WuZwMOn/lGvP7O7RpbDJ0LNpLynMs4/AqGvDIm7IdLwjxL4fTupB
 /e4m6pARjrDiB7mgJZu9NcWG0r82+M22xZS2uyEg4uGxnSkPPcQnQ7/TEhKsJOyXnFjK
 9i7OugmHLrMLUz3ayaJ02PLZoo3Zjw0qCyljxrBj2krr0qx9IVhqhs1CjeFM7Dcbupz/
 YqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Gy6Kb+oqE1M2CTgOLFPHiphkU8Pf6T4kljcQ0TYHTVU=;
 b=Il1RJSzCmtSH5z6ziWS+fny++dAFtpwSC6lbu27Q0g0Cd9JMXwVgXygFdHYHl77YaL
 LWuTJ9xoT0/l/ZQroKYv5m/L1wAnryb1O4Z3kEBnguU/skC+34la/wKBzJ8Q+2Em5DNt
 BgwBBnJRVAvyJlyPofoDBWfkEVqztM9PqZOKAdF7OJ1Gg3t1M0aR2gwqJmLfJEVf1I8C
 nKrfLnUleQ1sdH5A1MTCyj669lTKka4wh68Z2ZUT6FzyLxLlwzo9G9x1Wmd6yvk0eZY5
 +ZgS2/8sgJNSRCAaj6hIu4kULMQObxu9qb/oQHpSVgwDTGcZbkFAGIEcWgP210qh9aUB
 8g6Q==
X-Gm-Message-State: ACgBeo1uYSO/ktwxA0y/J3/VUsPJbmWg4cHRdb2U/ZfF+McnELXl9IVt
 bUaP4I8IQYRwkypd8Nyb66UiTQ==
X-Google-Smtp-Source: AA6agR5/mx8cBGntePvZ9MJc78oBFtP5Ueq4RXDHXG8BburmkNuGr/kyK++nJv+2Z12ZSXydMQ30QA==
X-Received: by 2002:a17:902:820f:b0:176:9654:354d with SMTP id
 x15-20020a170902820f00b001769654354dmr15316063pln.79.1662754714849; 
 Fri, 09 Sep 2022 13:18:34 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 s15-20020a17090a13cf00b00200de8ebc2bsm854051pjf.13.2022.09.09.13.18.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Sep 2022 13:18:32 -0700 (PDT)
Date: Fri, 9 Sep 2022 13:18:28 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 7/9] KVM: arm64: selftests: Add a test case for a linked
 breakpoint
Message-ID: <YxuflDM6utJbdZa1@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-8-reijiw@google.com>
 <CAAeT=FxJLykbrgKSC6DNFr+hWr-=TOq60ODFZ7r+jGOV3a=KWg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FxJLykbrgKSC6DNFr+hWr-=TOq60ODFZ7r+jGOV3a=KWg@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Aug 25, 2022 at 06:29:34PM -0700, Reiji Watanabe wrote:
> On Wed, Aug 24, 2022 at 10:10 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Currently, the debug-exceptions test doesn't have a test case for
> > a linked breakpoint. Add a test case for the linked breakpoint to
> > the test.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 59 +++++++++++++++++--
> >  1 file changed, 55 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index ab8860e3a9fa..9fccfeebccd3 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -11,6 +11,10 @@
> >  #define DBGBCR_EXEC    (0x0 << 3)
> >  #define DBGBCR_EL1     (0x1 << 1)
> >  #define DBGBCR_E       (0x1 << 0)
> > +#define DBGBCR_LBN_SHIFT       16
> > +#define DBGBCR_BT_SHIFT                20
> > +#define DBGBCR_BT_ADDR_LINK_CTX        (0x1 << DBGBCR_BT_SHIFT)
> > +#define DBGBCR_BT_CTX_LINK     (0x3 << DBGBCR_BT_SHIFT)
> >
> >  #define DBGWCR_LEN8    (0xff << 5)
> >  #define DBGWCR_RD      (0x1 << 3)
> > @@ -21,7 +25,7 @@
> >  #define SPSR_D         (1 << 9)
> >  #define SPSR_SS                (1 << 21)
> >
> > -extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
> > +extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
> >  static volatile uint64_t sw_bp_addr, hw_bp_addr;
> >  static volatile uint64_t wp_addr, wp_data_addr;
> >  static volatile uint64_t svc_addr;
> > @@ -103,6 +107,7 @@ static void reset_debug_state(void)
> >         isb();
> >
> >         write_sysreg(0, mdscr_el1);
> > +       write_sysreg(0, contextidr_el1);
> >
> >         /* Reset all bcr/bvr/wcr/wvr registers */
> >         dfr0 = read_sysreg(id_aa64dfr0_el1);
> > @@ -164,6 +169,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
> >         enable_debug_bwp_exception();
> >  }
> >
> > +void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
> > +                      uint64_t ctx)
> > +{
> > +       uint32_t addr_bcr, ctx_bcr;
> > +
> > +       /* Setup a context-aware breakpoint */
> > +       ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> > +                 DBGBCR_BT_CTX_LINK;
> > +       write_dbgbcr(ctx_bp, ctx_bcr);
> > +       write_dbgbvr(ctx_bp, ctx);
> > +
> > +       /* Setup a linked breakpoint (linked to the context-aware breakpoint) */
> > +       addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> > +                  DBGBCR_BT_ADDR_LINK_CTX |
> > +                  ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);
> > +       write_dbgbcr(addr_bp, addr_bcr);
> > +       write_dbgbvr(addr_bp, addr);
> > +       isb();
> > +
> > +       enable_debug_bwp_exception();
> > +}
> > +
> >  static void install_ss(void)
> >  {
> >         uint32_t mdscr;
> > @@ -177,8 +204,10 @@ static void install_ss(void)
> >
> >  static volatile char write_data;
> >
> > -static void guest_code(uint8_t bpn, uint8_t wpn)
> > +static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
> >  {
> > +       uint64_t ctx = 0x1;     /* a random context number */
> > +
> >         GUEST_SYNC(0);
> >
> >         /* Software-breakpoint */
> > @@ -281,6 +310,19 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
> >                      : : : "x0");
> >         GUEST_ASSERT_EQ(ss_addr[0], 0);
> >
> 
> I've just noticed that I should add GUEST_SYNC(10) here, use
> GUEST_SYNC(11) for the following test case, and update the
> stage limit value in the loop in userspace code.
> 
> Or I might consider removing the stage management code itself.
> It doesn't appear to be very useful to me, and I would think
> we could easily forget to update it :-)
> 
> Thank you,
> Reiji
>

Yes, it's better to remove it. The intention was to make sure the guest
generates the expected sequence of exits. In this case for example,
"1, .., 11, DONE" would be correct, but "1, .., 11, 12, DONE" would not.

> > +       /* Linked hardware-breakpoint */
> > +       hw_bp_addr = 0;
> > +       reset_debug_state();
> > +       install_hw_bp_ctx(bpn, ctx_bpn, PC(hw_bp_ctx), ctx);
> > +       /* Set context id */
> > +       write_sysreg(ctx, contextidr_el1);
> > +       isb();
> > +       asm volatile("hw_bp_ctx: nop");
> > +       write_sysreg(0, contextidr_el1);
> > +       GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
> > +
> > +       GUEST_SYNC(10);
> > +
> >         GUEST_DONE();
> >  }
> >
> > @@ -327,6 +369,7 @@ int main(int argc, char *argv[])
> >         struct ucall uc;
> >         int stage;
> >         uint64_t aa64dfr0;
> > +       uint8_t brps;
> >
> >         vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> >         ucall_init(vm, NULL);
> > @@ -349,8 +392,16 @@ int main(int argc, char *argv[])
> >         vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> >                                 ESR_EC_SVC64, guest_svc_handler);
> >
> > -       /* Run tests with breakpoint#0 and watchpoint#0. */
> > -       vcpu_args_set(vcpu, 2, 0, 0);
> > +       /* Number of breakpoints, minus 1 */
> > +       brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
> > +       __TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
> > +
> > +       /*
> > +        * Run tests with breakpoint#0 and watchpoint#0, and the higiest
> > +        * numbered (context-aware) breakpoint.
> > +        */
> > +       vcpu_args_set(vcpu, 3, 0, 0, brps);
> > +
> >         for (stage = 0; stage < 11; stage++) {
> >                 vcpu_run(vcpu);
> >
> > --
> > 2.37.1.595.g718a3a8f04-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
