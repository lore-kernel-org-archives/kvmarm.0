Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F364C43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 08:40:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F121F4CE79;
	Wed, 20 Jul 2022 04:40:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EDL2au1OmU6k; Wed, 20 Jul 2022 04:40:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B8E4CE7F;
	Wed, 20 Jul 2022 04:40:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2C94CE7F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 04:40:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DCLAQPtd5EKR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 04:40:06 -0400 (EDT)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6C064CA6F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 04:40:06 -0400 (EDT)
Received: by mail-pg1-f175.google.com with SMTP id bf13so15776627pgb.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 01:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=igHcvbbNIBEuhZc+DjfEJd6g7hQ4R/AxL0/SU2gdyWo=;
 b=roVHS8GqR9tX81QUvNAwTO3rEmwU/Z7n4o3+GbP1WjWEsaxBtQQSABAXlyUcYr6LuJ
 dtADQYwCslhmuwiu7Z6qn5ktJFp7VTIZMUE/DxCzf4iig8pOVeKnNLDS2Kx6K0IjZnHl
 ycZs0rKfB0VcoEIJBLrEE0QhjD8Liu+SXs/qFtvOi+w9IxnvuxmCfm1idG5tkjjCFJ9B
 iXeC/NY8n2efQm1dKqmIgavKVmyde5b+e8uk2DkiAoZk1Os8LnS7RcUAp0gkiKriJ6Pp
 ohObDwVencwUndBDLqeXXhbAhLxTCR92p0R24+l9coeXdGd6fO93iP48pfLHUTnpqEI1
 0C9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=igHcvbbNIBEuhZc+DjfEJd6g7hQ4R/AxL0/SU2gdyWo=;
 b=r9yXWfuUMWxmgYWc2uGOClpGtQah4sxz9GTQacq+3vBUTTWpiIT7cuPhLvnA8xkxN4
 CZugOLVeL0Ah6uDxse0pMtfpvZvcNSnjh/XT4KNxvA6AIBaKg/rFdCB6mS5bq0olgz4i
 GPC/Uu/JQCUVtjwiOeHsw7kj+HNvI1lHCzR7a4b+pNLhmJfTw00O3onmqBsbIG7Dsz0o
 iXcjvTRG18hjqWwVsv41ebNPua7jjxGE2T+OpntbBMCW5sfXyvDgTjeOCRtxhib7xLLz
 LWCM+XeMqOQr9m11Uf5OTZ0E2fkcgN7NSetabUYp+w/22pziIMzAW3A/6XAla6zV/Y4y
 cnFA==
X-Gm-Message-State: AJIora+p64xM+9phE31LgaQVpIa2eE266Kd6d75bIytqPIR97qeeCjYb
 L3h7XPG8elCA7uAi9lmlclkdtw==
X-Google-Smtp-Source: AGRyM1tzAi1dyHMpn7ivb+IEqLwTeryX+s06VifqPmCo3roiLkBrS3nZgdI466Wl6k5WeyOfSiRpeA==
X-Received: by 2002:a63:df15:0:b0:411:51f2:cc2a with SMTP id
 u21-20020a63df15000000b0041151f2cc2amr32751610pgg.533.1658306405477; 
 Wed, 20 Jul 2022 01:40:05 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 n13-20020a170903110d00b0016c27561454sm13456239plh.283.2022.07.20.01.40.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Jul 2022 01:40:04 -0700 (PDT)
Date: Wed, 20 Jul 2022 01:40:01 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <Yte/YXWYSikyQcqh@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87edyhz68i.wl-maz@kernel.org>
Cc: drjones@redhat.com, kvm@vger.kernel.org, oliver.upton@linux.dev,
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

On Tue, Jul 19, 2022 at 12:34:05PM +0100, Marc Zyngier wrote:
> On Mon, 18 Jul 2022 16:49:10 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > A chained event overflowing on the low counter can set the overflow flag
> > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > overflow.
> 
> Isn't this indicative of a bug in the KVM emulation? To be honest, the
> pseudocode looks odd. It says:
> 
> <quote>
> 	if old_value<64:ovflw> != new_value<64:ovflw> then
> 	    PMOVSSET_EL0<idx> = '1';
> 	    PMOVSCLR_EL0<idx> = '1';
> </quote>
> 
> which I find remarkably ambiguous. Is this setting and clearing the
> overflow bit? Or setting it in the single register that backs the two
> accessors in whatever way it can?
> 
> If it is the second interpretation that is correct, then KVM
> definitely needs fixing

I think it's the second, as those two "= '1'" apply to the non-chained
counters case as well, which should definitely set the bit in PMOVSSET.

> (though this looks pretty involved for
> anything that isn't a SWINC event).

Ah, I see, there's a pretty convenient kvm_pmu_software_increment() for
SWINC, but a non-SWINC event is implemented as a single 64-bit perf
event.

Thanks,
Ricardo

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
