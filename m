Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DE5C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 15:29:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A10220758
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 15:29:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="RWSt17Q/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A10220758
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C6DD4B14A;
	Mon, 18 May 2020 11:29:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ClNugG9RS5KS; Mon, 18 May 2020 11:29:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82A2A4B14B;
	Mon, 18 May 2020 11:29:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB074B148
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 11:28:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZTSS+0Dz62r6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 11:28:58 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A13E4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 11:28:58 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id m185so6076889wme.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 08:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4WixP9zOQESaEUk+grq6tjXSo20K+tLvJTvsRgnudUk=;
 b=RWSt17Q/P+CTGFhSHnF5vSVIgqEukfT/ue7prWyK3v1ihEQJc74VjQg5Bf31WcJ8k4
 jouQvwUwfngsU4A8QwLSizOwMcPiatSqqmPp2eqpf6+ZgdMWG/CwdnXnaFSH95kncofW
 /3vslGy5j3My4P0CocjIZaqunf0B3RGMsfOFHTDhT1yA7eMR65w13RBfRRWu9A2RRq3w
 PhKzgdxDPMxyMmYxNMqqiqB7BAkv8RHT8Cfw12/pH5LYoKTZyT5pss5xdr7wLA3w5YHj
 TGlG5y2rQLbmZQRREQPmyNEeDBoqsCtgSPI8DYfBiw0OQQSr8AvpQOsVY9LVCxvlB54i
 kMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4WixP9zOQESaEUk+grq6tjXSo20K+tLvJTvsRgnudUk=;
 b=eNJZADSPwf26zAMFqnloZI5fZsthd3yCbZl0K5GRBnadtj5/GEBMm9krGzbnk9WqJV
 rsgHkGXlvze9pRuy3+LX29bj1FIFQz1kBpfoLMJZ3EH3j7hZrYo20No7jXwTFXVVbXTl
 aHhks+lKpnj/tfvYYoN7T/GXmF0v4QnNEnEIkSjwkwsn4+M4PqeKDe4HvbblJYPBWNN/
 k/ycHGi60Lc+vOmrJ4IQRVbSD015H3EuJHedHKxLY7KVzuMCfeoRdMze5oBvWDNAQOBZ
 tM2xyL+sYFf4uW492Pc16DVtJQHiovDD2M1enAxMeiw6R7I7P7sWrrmbSqTaJfp37rED
 SP0w==
X-Gm-Message-State: AOAM531zSPg5FxmiWkYO6Yd5umluphnNtKDyIV1a1TlyCiy8uKbC33Gs
 SSQQK/wThqJYyb7maZrmIzm8MA==
X-Google-Smtp-Source: ABdhPJxNgUPicwALsWOh/eNYOxbadohP9rcnrjnk2Eie3S7vO1kCgSNAmXH0HQ9ZKDHh7XTExrpDBg==
X-Received: by 2002:a05:600c:1006:: with SMTP id
 c6mr20951848wmc.133.1589815736776; 
 Mon, 18 May 2020 08:28:56 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id r2sm17269506wrg.84.2020.05.18.08.28.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 May 2020 08:28:55 -0700 (PDT)
Date: Mon, 18 May 2020 16:28:51 +0100
From: Andrew Scull <ascull@google.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 07/14] arm64: kvm: Split hyp/switch.c to VHE/nVHE
Message-ID: <20200518152851.GA147668@google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
 <20200515105841.73532-8-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200515105841.73532-8-dbrazdil@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Fri, May 15, 2020 at 11:58:34AM +0100, David Brazdil wrote:
> +__kvm_nvhe_sve_load_state = sve_load_state;
> +__kvm_nvhe_sve_save_state = sve_save_state;

Building without CONFIG_ARM64_VHE leads to a linker error due to the SVE
functions being referenced in this list. This is caused by
CONFIG_ARM64_VHE disabling CONFIG_ARM64_SVE and, in turn, preventing the
generation of those symbols. There aren't any references from code, just
this file.

It can be resolved by having the SVE symbol aliases depend on
CONFIG_ARM64_SVE.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
