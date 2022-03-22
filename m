Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1533C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 05:49:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09F7949EFE;
	Tue, 22 Mar 2022 01:49:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zolGMAf8SwQU; Tue, 22 Mar 2022 01:49:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8B5349F00;
	Tue, 22 Mar 2022 01:49:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1615B49EFE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 01:49:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 18PHY9CdoIDC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 01:49:34 -0400 (EDT)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
 [209.85.166.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B414849EFC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 01:49:34 -0400 (EDT)
Received: by mail-il1-f176.google.com with SMTP id r2so11818474ilh.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 22:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bWjZMLU+VFCSrR0lmrzXv5X+bH9F7caMUKl8oy21g1s=;
 b=GNd7/xXpwD7cgS56Oo4ahnoy7Q/tYMIQk8nR9PdKbphhOdpbUdRhugE5U0c0v8mpWy
 8ePlQ22UlEluvp5V4IOKUMXV9oWogrhbFplL/M5bGE9qVUyINV5ij+W1Vl7GW5Z1ajXv
 2/FZw0j8nTQ4pXXJ+9AzPRVRpMWwWvG/et9yer0dNhBSogswjZT+HBwaNpVn5PsKP7Vw
 IJk1dHlDRIWSNkpwek/bemefUZkMrugq3DmD2xpMWMXzn+lxOcY9CMWJL+ucofgz8Uxu
 uZnPsxwJI34uyrVxWyTgkrX4JJ2NXeEQnFShMQpdcgghgxvETg1xaV24K/RTfWSNJ7rf
 Uk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bWjZMLU+VFCSrR0lmrzXv5X+bH9F7caMUKl8oy21g1s=;
 b=iYgiimt1jiZ+K2EOqcWrgb6SeTPSlgNUEtcFMeJpWnGGcJKtTNMi5DxA10wMBLcBZH
 37Nh+0yS/4jd5PSnNWKhJFA/jHY1B1B8t5VugzRfsWpc7nTtuzm4joOk5p2RGbKbmgP1
 ElMvP+qgSsmdTSCkb2ogUmZawesWxg6UCqMPtwKDOF6lbP2fFUuhWWUN/HNhBiYQiyjW
 KGX5PNj10e7W/JdagF2NSU686L87oT3YClv326cur4rqsXhx2b1R7j9xtT+7+vlVYoiK
 N8ZVwOCWLN1sbcBA+8a0b8E1kFThDHzbbZqAVBAuZeOjdftwxZCNfW3E2CJKapp/rpPe
 SUlA==
X-Gm-Message-State: AOAM530R7++2y4J4E+vlqDsFnnVhscQJ6w5wLVV25OGL/HgzRWI0l/7v
 yIu/03jMxViuV2oPZMkU+NIxcQ==
X-Google-Smtp-Source: ABdhPJyYsgwXPFau1PVGew3KMrIqlZSvQU08WKe/gwzt6lhUP9tczQJPrl7k58LJ0N+qJV996Ll1pA==
X-Received: by 2002:a92:cbc3:0:b0:2c6:78fa:41e9 with SMTP id
 s3-20020a92cbc3000000b002c678fa41e9mr11457667ilq.112.1647928173864; 
 Mon, 21 Mar 2022 22:49:33 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 k11-20020a926f0b000000b002c2756f7e90sm9842447ilc.17.2022.03.21.22.49.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 21 Mar 2022 22:49:32 -0700 (PDT)
Date: Tue, 22 Mar 2022 05:49:29 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2
 from AArch32
Message-ID: <YjljaS3Jeste4/ID@google.com>
References: <20220318193831.482349-1-oupton@google.com>
 <20220318193831.482349-3-oupton@google.com>
 <CAAeT=FwR-=U_0WvKqV4UTCmo8x1=atBVtTQeirwiF3XCo+S=1g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FwR-=U_0WvKqV4UTCmo8x1=atBVtTQeirwiF3XCo+S=1g@mail.gmail.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Mar 21, 2022 at 09:41:39PM -0700, Reiji Watanabe wrote:
> On 3/18/22 12:38 PM, Oliver Upton wrote:
> > The SMCCC does not allow the SMC64 calling convention to be used from
> > AArch32. While KVM checks to see if the calling convention is allowed in
> > PSCI_1_0_FN_PSCI_FEATURES, it does not actually prevent calls to
> > unadvertised PSCI v1.0+ functions.
> >
> > Check to see if the requested function is allowed from the guest's
> > execution state. Deny the call if it is not.
> >
> > Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
> > Cc: Will Deacon <will@kernel.org>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Appreciated :-)

> BTW, considering the new kvm_psci_check_allowed_function()implementation
> in the patch-1, it might be better to call kvm_psci_check_allowed_function()
> from kvm_psci_call() instead?  Then, we could avoid the similar issue
> next time we support a newer PSCI version.

Good point. If Marc doesn't bite in the next day or two I'll address
this with a new spin, otherwise I'll do a separate cleanup. Just want to
avoid spamming on this topic since I already replied with yet another
patch [1].

Thanks!

[1] https://lore.kernel.org/kvmarm/20220322013310.1880100-1-oupton@google.com

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
