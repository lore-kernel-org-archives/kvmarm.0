Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB25C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 05:28:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 154F94B0B8;
	Mon,  4 Apr 2022 01:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 62xrv9DrtAqs; Mon,  4 Apr 2022 01:28:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1A74B0B9;
	Mon,  4 Apr 2022 01:28:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A31CA4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 01:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 24PSfSCS4Br7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 01:28:38 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2DE74B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 01:28:38 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id g21so9914426iom.13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Apr 2022 22:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4vQFrjglrchZfWnBhpFno0OG8+JYEPYgRfkxp+2Eq7o=;
 b=LiOBtM7e9EsGoXdzZHjt3VAlfi+P8jggYvXUvinv1GwvKXhD/C1MVwLT0WYFC4rAGp
 jmol3SXOFoa4Z4ooFSn6wsQKtk8C3Lub7I7baeX4E74lH/ovookztTEfvijFA4NvE4yk
 Wjt7jhgVAkfRGf4TYEeICMrubHLMEH3B+edLHVG3HJr27PFedThMd11inj5vbzFOhq96
 vBZU9QHgDlLdKkJugc7xPxBG/N9cSEvyLt5EBYWMKySVdKf7U4oUVmzo38Mv4CikzJr+
 w1TfMl2QfEk6pVs4s09A2AqAYL6GMRWZoMh4P8xfkPK2EgaK2cujVFdvqxTkGY1/5ON9
 rMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4vQFrjglrchZfWnBhpFno0OG8+JYEPYgRfkxp+2Eq7o=;
 b=BWhtG+ltdlD2SIsvpAigmMhO14cJd0f2gFGYE7npxp+YQj26AoT/G5zP3uzs1Ut2fC
 kvJZMb9GejXbiIuyl/VFbLSTGvaToK01VGSKFd0GLueAUsYPs3VYMqYU3dy9DaXW89oi
 NP+ngCiDTjz8ceMUUri3j09RkpQYpePbAOIX/dyLQ+6Wtr58S3/EcvmawkzYHmK2ztOc
 Zi1Fs4cEtwhAV3vnnRU+VdSCFOCWGRzsRmHVXqyWaA5L8kGUC1zwB2LUxdGixH3DazT+
 Sq9aBRPiX7ewN/xgr9Vmi7pDS6NS9zOpD9ePfQujzGqj7X1es+Ly3JhKmp/jta92ER6H
 lWoA==
X-Gm-Message-State: AOAM530cDtYnV03TckGq1JTOYAmPtBHQDnTqgE+l7sRH9GyROfjO4Cf2
 DCtH4YcwzfavMJKppmo7ExpunQ==
X-Google-Smtp-Source: ABdhPJwnrz63bQuIY0Qz/p4MN+rMjCvcRj6uMmNM+SGy8AWlCr6QKV0I4658w5YLbDhl2gu2ASyxBg==
X-Received: by 2002:a02:224d:0:b0:321:370b:6d59 with SMTP id
 o74-20020a02224d000000b00321370b6d59mr11248053jao.104.1649050117857; 
 Sun, 03 Apr 2022 22:28:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 u10-20020a92da8a000000b002ca48fff4c7sm435056iln.13.2022.04.03.22.28.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 03 Apr 2022 22:28:36 -0700 (PDT)
Date: Mon, 4 Apr 2022 05:28:33 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the
 AArch64 sysreg handler
Message-ID: <YkqCAcPCnqYofspa@google.com>
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-3-oupton@google.com>
 <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
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

Hi Reiji,

On Sun, Apr 03, 2022 at 08:57:47PM -0700, Reiji Watanabe wrote:
> > +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> > +{
> > +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > +       u32 esr = kvm_vcpu_get_esr(vcpu);
> > +       struct sys_reg_params params;
> > +       int ret;
> > +
> > +       /* UNDEF on any unhandled register or an attempted write */
> > +       if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
> > +               kvm_inject_undefined(vcpu);
> 
> Nit: For debugging, it might be more useful to use unhandled_cp_access()
> (, which needs to be changed to support ESR_ELx_EC_CP10_ID though)
> rather than directly calling kvm_inject_undefined().

A very worthy nit, you spotted my laziness in shunting straight to
kvm_inject_undefined() :)

Thinking about this a bit more deeply, this code should be dead. The
only time either of these conditions would happen is on a broken
implementation. Probably should still handle it gracefully in case the
CP10 handling in KVM becomes (or is in my own patch!) busted.

> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Appreciated!

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
