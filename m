Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80734C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 17:13:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F334920706
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 17:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gQSZ2Bq3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F334920706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C0B4A95C;
	Thu, 25 Jun 2020 13:13:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wOHFmTlMKfgR; Thu, 25 Jun 2020 13:13:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E38F4B08B;
	Thu, 25 Jun 2020 13:13:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBBC64B0C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 12:37:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sdx4pZfvvOcT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 12:37:38 -0400 (EDT)
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF4A94B09C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 12:37:38 -0400 (EDT)
Received: by mail-ej1-f68.google.com with SMTP id w16so6596333ejj.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=VwAmIR6VLB+YcfnphtZyHLrRryQdawnk8xblq99lNpw=;
 b=gQSZ2Bq3lC6LnQf8Wk4oi/jk/M+PtWAEGUIJCVTZFd0D2FgW/K9QRB/MBUeqIapMP2
 /sptmreyARmDtm0x+VJyFlWrnJYPyMZ+ttEIz90lDqC5HgCFT7Sa9J3PkEw6zc2vC6E9
 LZMTXIezWvX1sXa4VXd8MP2OhCyn8sVufJvL5pg0Gib0H4HumVaCUqZfoHQcodemyQNQ
 FiZLQPHjwFUJN9aXTdGSO4hsSNX5D1r6fI6himeDy/+J6yaGZvSH11f6o4IEAsmu2xj4
 /W6b1OyjVmrA4rD/MjrQk5RJWIBms9dkbPYUyyQcZZEtNkcrBTBFDMNX2nYasOUGJwtU
 zacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VwAmIR6VLB+YcfnphtZyHLrRryQdawnk8xblq99lNpw=;
 b=JvGW1oLXpBDWzYRJbB7Eghp9ICLt06/ISJsXADtIhHY4FIOQb5X6eJGlPQc7ZuZTm4
 91z00nmblD2nGbqz+nLxQ5g3P2o9W0UWeHU1OnGx9sRgNA95aJ3Jhlzhhv0y0tRdJFrh
 KSFoNxcjI8wCwYJs8QoUVXJ4w9XFe24oBMaSWUKPKMp0DNtrzF2XUOT3T4UCurnUFL4H
 s7TjCgQ8BGGyIwsBkU7Hdy+6E4nYmi/O7Q98PmvaC1ZuWwBKdSIqFmLAIE9KWUPZBLIA
 CrpP7MOB3179fReCy8Y7SNd1UpD2o99JrdCbMEJ1Q/qte7+TVzNrQ5TDrC9z0H40N89M
 gGiA==
X-Gm-Message-State: AOAM531ZY70OBo9YeQutwrDNTGOWVmwUTtT51G9pjOcyyyHzUVFwAfGh
 Yuf/BtRycwp2XrhGH59Kkes=
X-Google-Smtp-Source: ABdhPJxvrRXlwZ2mp6kReJp3W3P2fYlzehlk3EWz7EpOv4/Pv2iiKdP8/uQ7IcJvK12FBnscwEgQwQ==
X-Received: by 2002:a17:906:fcc1:: with SMTP id
 qx1mr12562143ejb.379.1593103057718; 
 Thu, 25 Jun 2020 09:37:37 -0700 (PDT)
Received: from ltop.local ([2a02:a03f:b7f9:7600:7032:f41f:3b67:e84b])
 by smtp.gmail.com with ESMTPSA id u60sm11052049edc.59.2020.06.25.09.37.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 25 Jun 2020 09:37:36 -0700 (PDT)
Date: Thu, 25 Jun 2020 18:37:35 +0200
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 08/15] arm64: kvm: Split hyp/switch.c to VHE/nVHE
Message-ID: <20200625163735.yneq6lzpmfst2pak@ltop.local>
References: <20200618122537.9625-9-dbrazdil@google.com>
 <202006251244.YDWclRrq%lkp@intel.com>
 <d807e83db1f1052378b6998f683e4617@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d807e83db1f1052378b6998f683e4617@kernel.org>
X-Mailman-Approved-At: Thu, 25 Jun 2020 13:13:30 -0400
Cc: kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 android-kvm@google.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 25, 2020 at 09:16:03AM +0100, Marc Zyngier wrote:
> 
> I really wish we could turn these warnings off. They don't add much.
> Or is there an annotation we could stick on the function (something
> like __called_from_asm_please_leave_me_alone springs to mind...)?

There is: '__visible'.

-- Luc
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
