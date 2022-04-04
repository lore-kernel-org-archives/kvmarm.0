Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8AAC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 23:19:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 494FE4B285;
	Mon,  4 Apr 2022 19:19:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N1VIRHHYFO+4; Mon,  4 Apr 2022 19:19:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EA2441003;
	Mon,  4 Apr 2022 19:19:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88B1141003
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 19:19:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dz3vctYBsF-l for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 19:19:30 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FD2A40597
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 19:19:30 -0400 (EDT)
Received: by mail-io1-f48.google.com with SMTP id g21so13181527iom.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 16:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4HQuxb/8RWMSgNIJitUFJzaBlGJWxUNK7LO21+WkcG4=;
 b=Et2iWkTnW2r9yego6aq6wuHaWBZ4EPhFdAlYbpl3fySBWEZ2suJ7cmpKbqAZVDEYJV
 penv5MLm4ibzzjyZiCG+sRGdi8Owm7364yw8WjIBdlTFlfXoBJO7+FNNr9McLPDqsk/+
 Wk3JJz1J8PkUOamRTT2csAmTyuLOZGX07uWOwgNGZ1je/MbzCba3qb/ZUCyBExVSbyUT
 pMee689hFU90nSNMhNGDq3sULdZzSgRygc/zJleZXc6y0m6EZ+663aM9zSvn4AgP6AsS
 4zwbH01jcZUOsOFgfWw1EUdI9wee7r/o5gNsIU9levXCN6L9MQE2pBXPeWowZWRd2Rr2
 JePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4HQuxb/8RWMSgNIJitUFJzaBlGJWxUNK7LO21+WkcG4=;
 b=sj1E4HZ5Rw9QvPZjGYcq00NXfR0rEeVCleT09pOWIyCiCapX0r7HtIyUOGG0DbyTvH
 hytGnVytEIETsuQOvuJDXamP51hoHWkHdFgvnZRu614LJ9Qja4IVzckiFbrpjUa60fHk
 q2v84HbzER4OLR5TTaTfCg52Le2+6VQjmcbXeyxEXAR82/8wyRbpbR3uouj0k00vaH/n
 DQ10kAw5u8oG1mA7nDbDhVLffFjLn8beSh1c4C7/5QVCo7gllrzwZqD9077R4f51EoTT
 q9dj63+fjiriiEIxeQxGH4Hz3RtsRcVWE24chjlhVWQnO8uqJpo+WZjvUtwWzyeuZMSE
 U5Mw==
X-Gm-Message-State: AOAM531L7YKcC3ch46qWPgKr/BsgPXkndqz8dxhIJqSwJpPKIhm+MZzl
 Hj+JKFeCK5bq0Euxk1wnN9m53g==
X-Google-Smtp-Source: ABdhPJybHp4SBT2pqY9bfoXsSLyxE3+imCY7mtDDFkk9g25hqxAWHP1Ohh8UmDjlZHjJtCgPNsazsQ==
X-Received: by 2002:a05:6602:80a:b0:649:f33:ecb2 with SMTP id
 z10-20020a056602080a00b006490f33ecb2mr344836iow.150.1649114369644; 
 Mon, 04 Apr 2022 16:19:29 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 s10-20020a6b740a000000b006413d13477dsm7067073iog.33.2022.04.04.16.19.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Apr 2022 16:19:28 -0700 (PDT)
Date: Mon, 4 Apr 2022 23:19:25 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the
 AArch64 sysreg handler
Message-ID: <Ykt8/Q5LLpZdgLu5@google.com>
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-3-oupton@google.com>
 <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
 <YkqCAcPCnqYofspa@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YkqCAcPCnqYofspa@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Apr 04, 2022 at 05:28:33AM +0000, Oliver Upton wrote:
> Hi Reiji,
> 
> On Sun, Apr 03, 2022 at 08:57:47PM -0700, Reiji Watanabe wrote:
> > > +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> > > +{
> > > +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > > +       u32 esr = kvm_vcpu_get_esr(vcpu);
> > > +       struct sys_reg_params params;
> > > +       int ret;
> > > +
> > > +       /* UNDEF on any unhandled register or an attempted write */
> > > +       if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
> > > +               kvm_inject_undefined(vcpu);
> > 
> > Nit: For debugging, it might be more useful to use unhandled_cp_access()
> > (, which needs to be changed to support ESR_ELx_EC_CP10_ID though)
> > rather than directly calling kvm_inject_undefined().
> 
> A very worthy nit, you spotted my laziness in shunting straight to
> kvm_inject_undefined() :)
> 
> Thinking about this a bit more deeply, this code should be dead. The
> only time either of these conditions would happen is on a broken
> implementation. Probably should still handle it gracefully in case the
> CP10 handling in KVM becomes (or is in my own patch!) busted.

Actually, on second thought: any objections to leaving this as-is?
kvm_esr_cp10_id_to_sys64() spits out sys_reg_params that point at the
MRS alias for the VMRS register. Even if that call succeeds, the params
that get printed out by unhandled_cp_access() do not match the actual
register the guest was accessing. And if the call fails, ->Op2 is
uninitialized.

Sorry for backtracking here.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
