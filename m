Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B899CC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 18:28:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0AB5B2343E
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 18:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AB5B2343E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8854B12E;
	Wed, 13 Jan 2021 13:28:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qgB2miJyAz4m; Wed, 13 Jan 2021 13:28:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 480494B1CB;
	Wed, 13 Jan 2021 13:28:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 309834B1B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 13:28:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cmDuVRaLre87 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 13:28:46 -0500 (EST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F25114B184
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 13:28:45 -0500 (EST)
Received: by mail-wr1-f43.google.com with SMTP id t30so3206498wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 10:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=oCAeIb7ECFW6QlWgtdlZyS84pPretLI5vdf+tM6RJD4=;
 b=Uibh+vbAZVnETjtRBAkiqx6q2IIG4VTxEpRIY6uh618odCokYJk2Rp/NUw7U3mbcW1
 c0tPK4C6kRxMB8tg7NnAbADmglLr3wrGuVJd15fHX2E3d3aBfjULp3XBytVT9QuCf3ZD
 9uMv+jG3r8lckQp7NEWv/Xv/fjoE1O1qB+K7aiudPgD1EWs9VA+Z5xvZyn5VUhOyei99
 NezwTAoysxwKeO53Xew9XxWLRzfG30JNyCBZSVGL/z25EOMeB38vLAo0STXqBorTf20H
 9+vSMtKPiCN2/fiXYM8SJ0jdTxSZS70B1MQr5SlM5E8Ly8x3Vyk36MYman3txbdX/h4N
 xQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oCAeIb7ECFW6QlWgtdlZyS84pPretLI5vdf+tM6RJD4=;
 b=cWjgWGRQRAzYZY+oBecHFj/PNlNqq8o5zOLOja01Y443pG8E1aQtsi2KS95/5fCFpE
 inDCNLxgQDgX6qVNwCxGWwIbV1lda4Y1drzYcJFWN63F68cks+RtuofCzzDMdau4vM1x
 t3mZzYgDjKR6yzx2aGUjqROnYZeQnCLqLEyXIw8VeCVjLkYgVScWJjOxl7PVxz4YW3IZ
 OA2ijdxFtalEkSmmRO/uNFLI1QiXD9n9WgDK2SEzc6mnmq639GYcaozaa3XnS91pgEyM
 SbUQUbvebyB7jRX8EtkkYaF8LRKwqR/TlgGbTKcdIHunYiY0uQFUXc4igG1C7yTZpNwG
 PQdw==
X-Gm-Message-State: AOAM533BW3fWN5ysH+XsbUdzm6pMWX1p87vA1TfCxayoC/yUgQCK1g4p
 bRKufW+B0sE/hjsJtUXyY41fQQ==
X-Google-Smtp-Source: ABdhPJw07pkMlp/wa7hOyU26GePo2LXD56vW96vj5Sk6xZIiiPoUrxPmL1/QeYsYtlYpnqzeZtt8VA==
X-Received: by 2002:adf:97d2:: with SMTP id t18mr3944967wrb.228.1610562524885; 
 Wed, 13 Jan 2021 10:28:44 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id b14sm4485354wrx.77.2021.01.13.10.28.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 Jan 2021 10:28:44 -0800 (PST)
Date: Wed, 13 Jan 2021 18:28:41 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH v2 13/26] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <X/872aaC/E4MwMa6@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-14-qperret@google.com>
 <d55643ea391f73a2297f499f3219ba8a@kernel.org>
 <X/8CR5eXGGccFjaL@google.com> <X/8FFKOLOVD9Ee2F@google.com>
 <e09900ba30646cf23e1683a2ed16078f@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e09900ba30646cf23e1683a2ed16078f@kernel.org>
Cc: devicetree@vger.kernel.org, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
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

On Wednesday 13 Jan 2021 at 17:27:49 (+0000), Marc Zyngier wrote:
> On 2021-01-13 14:35, Quentin Perret wrote:
> > On Wednesday 13 Jan 2021 at 14:23:03 (+0000), Quentin Perret wrote:
> > > Good point, that would be nice indeed. Can I use that from outside an
> > > __init function?
> > 
> > Just gave it a go, and the answer to this appears to be yes,
> > surprisingly -- I was expecting a compile-time warning similar to what
> > we get when non-__init code calls into __init, but that doesn't seem to
> > trigger here. Anyways, I'll add the annotation in v3.
> 
> That's surprising. I'd definitely expect something to explode...
> Do you have CONFIG_DEBUG_SECTION_MISMATCH=y?

Yes I do, so, that doesn't seem to be it. Now, the plot thickens: I
_do_ get a warning if I remove the 'const' qualifier. But interestingly,
in both cases hyp_ftr_regs is placed in .init.data:

  $ objdump -t vmlinux | grep hyp_ftr_regs
  ffff8000116c17b0 g     O .init.data     0000000000000030 hyp_ftr_regs

The warning is silenced only if I mark hyp_ftr_regs as const. modpost
bug? I'll double check my findings and follow up in a separate series.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
