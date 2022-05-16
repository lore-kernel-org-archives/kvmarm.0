Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB49C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 10:42:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D2EE4B1F8;
	Mon, 16 May 2022 06:42:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xN8BWhE5qsua; Mon, 16 May 2022 06:42:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27F7F4B11A;
	Mon, 16 May 2022 06:42:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C22B14B0DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 06:42:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UXSB+S5Odlwv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 06:42:03 -0400 (EDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
 [209.85.208.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E31D49F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 06:42:03 -0400 (EDT)
Received: by mail-ed1-f50.google.com with SMTP id p26so1491142eds.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 03:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=erbXfCmeHocQjfL+rgDZPz13+JsufODTkqH4MW8FPkU=;
 b=P77DC0Il8yTtkstHIFJR8Nqlq8byFBHMvwFcvt4Nt22CzyvC/Fv+KdNgonw4S3OD3K
 2LvZ1t/0q7xkgaqJ5UbQef9PLfEU7ibZjarM7y30f4syi3XrIkk66bNTygONFoWTGBsW
 T0zLbcuIOAC9Pea0Sj+b22Ih6ju5PVW+bGFZBfbQIQwsZ2smRedVpMeslKaL1/f8c8ws
 cpfStIYgXZGpFXthRtvUGpT3DV00iZ9sg3V6xgZDESod1iRqB5UonePNMTjP7uGf8dB4
 IBqMuAHh6o186Vqyr9HRq/GyB3509vT7hUFGMlFByEIaa6lwVHd0K6KyZqrr3pKGyAHv
 dkfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=erbXfCmeHocQjfL+rgDZPz13+JsufODTkqH4MW8FPkU=;
 b=pCgWJoSDy5cxP5f7LNwEDRflWy/Dl/ELbje0/1KZlaIcM8sLmE+zXBZNYw2hQncSQD
 uk9cZRakzWritpOlaS0ZA3LCIY0ycWp1DBwZqxmbJ9xFywG9zPhL3/3kR1Wcl+rPnHz6
 9S/TV+GpBepXiEXSnGNPg16Ve/ZzY/GlLSDKjeUAjfBhNNztffkbwvrkv0lt/GLrLOIP
 nfgTanG9BkarDY6mK+GoH8cjA+KU0B+JEWj2WmtGcY2RsCKvoaSl7pPJYQ6M22uO8uwv
 k6xaTuX5HUdx/OGnFf+ygz6u03tWlWNlgmGTv2/MkULx/J9QZeMAn9X/ZPCiIXLV4PNq
 wDVg==
X-Gm-Message-State: AOAM532i8x9xEzM7v7h9nkn5v569O8YC8BJvQakGXZxaeNTbvirHWrw7
 +d/g4f7ICCWaDnxlcIjJtUXzrg==
X-Google-Smtp-Source: ABdhPJwCmZ7TsADf4yBSO70bp+4Cv2yZYtgdUiE6w+q/M7boOVpmbsE2ZQrGrh1nN3VKR0CPmxFF2w==
X-Received: by 2002:a05:6402:2710:b0:427:d087:b with SMTP id
 y16-20020a056402271000b00427d087000bmr12509532edd.11.1652697721952; 
 Mon, 16 May 2022 03:42:01 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com.
 [34.91.171.30]) by smtp.gmail.com with ESMTPSA id
 ec33-20020a0564020d6100b0042ab48ea729sm1151662edb.88.2022.05.16.03.42.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 May 2022 03:42:01 -0700 (PDT)
Date: Mon, 16 May 2022 10:41:58 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Don't hypercall before EL2 init
Message-ID: <YoIqdiOoCf0A1hcV@google.com>
References: <20220513092607.35233-1-qperret@google.com>
 <87sfpb59wj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sfpb59wj.wl-maz@kernel.org>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sunday 15 May 2022 at 12:10:20 (+0100), Marc Zyngier wrote:
> Can we simplify the condition? ARM64_SPECTRE_V3A is only set when
> !VHE, and we already bail in kvm_patch_vector_branch() if we see
> VHE+V3A, because the combination makes no sense at all. I think this
> can be rewritten as:
> 
> 	if (kvm_system_needs_idmapped_vectors() &&
> 	    !is_protected_lvm_enabled())
> 
> Thoughts?

Yup I think this works as both CPUs that are vulnerable to V3A aren't
VHE-capable. But if we ever get a VHE-capable CPU that's vulnerable I
think the next call to create_hyp_exec_mappings() will BUG(). Perhaps
the alternative would be to have has_spectre_v3a() say no in VHE to be
on the safe side? That is, prevent the cap from being set to begin with.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
