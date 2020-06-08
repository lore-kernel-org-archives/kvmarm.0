Return-Path: <SRS0=JvcX=7V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40595C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 17:09:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7BCC2076A
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 17:09:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="p1wdQUod"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7BCC2076A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 411B64B150;
	Mon,  8 Jun 2020 13:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y8nQNPuttTV8; Mon,  8 Jun 2020 13:09:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4347E4B13B;
	Mon,  8 Jun 2020 13:09:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBF24B0F9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 13:09:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gcJpJt19lG8O for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2020 13:09:27 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12BF34B0D1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 13:09:27 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id q25so296481wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Jun 2020 10:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=O5kyIIzxsOCQ0wtFJtMJAdBIg3y6KuYFhCf9iMzgFJQ=;
 b=p1wdQUodkbKA53RU829/S14bgNwXUZk4oaZTZITlLvC1R/7pCLt8Qec1xAGFhamIuc
 6GF1n0XpMYAVGZKMywm22h1ALDMPKC6G/E5cO+DrxJ5qCSzcWyrUHMqFumgbHdUB4PKI
 NXGPYjtcPBb58hKLeEFKZhEW3c+c7gfIsbHDkzXKT86fv2c6LRGCjIStT6NFcC/RFCUV
 Cd6FPlkFGwdFBPcY9Gu+WoR99u+T8tOtU2rKJ8OttEpNZZcKTZiS/TQdIyt7UoWh0mnL
 jSWwEg9ye92wgPswhOn2ZJsE21UwfoMC1vNYT56fDTeseRBdlyb87eNnOHq3gueSJbtm
 +Z4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=O5kyIIzxsOCQ0wtFJtMJAdBIg3y6KuYFhCf9iMzgFJQ=;
 b=ay7gEE/nB3nnnntT5tAm06dDXoDsqMvlP7RPSaSjBdRTMt7l2v2Bb2QzaB921WgnMf
 dgpWpBww69lxSo3L4jeVDUk4pt56827O0G9v8IR6OGb63aJTMclPg8uCujMJU49l1Skq
 e83PufEfGVu/qeDjHA2xkoVPAnw7l+VcsPgN097PYVpq1J6mpGMZXXB/h0cUKcNIikGx
 dKxKF3oszjxrC9J+b2xyvSEwu4FvqSmgxOkkf/S0ftCvCwrV1fvaE6bKVJD1p3M3zDpL
 /Oj75cYlZ+8XVjM5Jh7MgAq5msOVhRO2tgk4oUZwOxT/DpzIsie9iUl5cdorj1wG5bIV
 Jjpw==
X-Gm-Message-State: AOAM533shXuEu/kXb5wo1aIFYsQuivlLorWDhoT+faURdbI/vN0813Zm
 YNqAvhP/5R54WeRDIfP8fKtVOQ==
X-Google-Smtp-Source: ABdhPJxZEDJueTXgTcDW9U9iUaISMszgUVW6R1TTHIBvERHVRmV8seKAaqqSKuvHuMRooFnwn0NlQQ==
X-Received: by 2002:a7b:cc08:: with SMTP id f8mr350455wmh.106.1591636165854;
 Mon, 08 Jun 2020 10:09:25 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id z8sm357180wru.33.2020.06.08.10.09.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 Jun 2020 10:09:25 -0700 (PDT)
Date: Mon, 8 Jun 2020 18:09:20 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Remove host_cpu_context member from vcpu
 structure
Message-ID: <20200608170920.GC96714@google.com>
References: <20200608085657.1405730-1-maz@kernel.org>
 <20200608145145.GA96714@google.com>
 <1a00887a4af019fa83380b68afd43a29@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1a00887a4af019fa83380b68afd43a29@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Jun 08, 2020 at 04:42:42PM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 2020-06-08 15:51, Andrew Scull wrote:
> > On Mon, Jun 08, 2020 at 09:56:57AM +0100, Marc Zyngier wrote:
> > > For very long, we have kept this pointer back to the per-cpu
> > > host state, despite having working per-cpu accessors at EL2
> > > for some time now.
> > > 
> > > Recent investigations have shown that this pointer is easy
> > > to abuse in preemptible context, which is a sure sign that
> > > it would better be gone. Not to mention that a per-cpu
> > > pointer is faster to access at all times.
> > 
> > Helps to make the references to `kvm_host_data` clearer with there now
> > being just one way to get to it and shows that it is scoped to the
> > current CPU. A good change IMO!
> 
> Thanks! Can I take this as a Reviewed-by or Acked-by tag? Just let me know.

Build and booted your kvm-arm64/ptrauth-fixes branch contianing this
patch with VHE and nVHE on qemu. Booted a VM within each with kvmtool.

Reviewed-by: Andrew Scull <ascull@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
