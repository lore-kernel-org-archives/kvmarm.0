Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F844C64E7A
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:51:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B340E22244
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="nkgSXV2g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B340E22244
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F194C268;
	Tue,  1 Dec 2020 08:51:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P4EgvKaUVCsj; Tue,  1 Dec 2020 08:51:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EA4F4BCAD;
	Tue,  1 Dec 2020 08:51:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D6364BCAD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:51:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tx4b1F4d2lTx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 08:51:39 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B2C34BC53
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:51:39 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id p8so2739562wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Dec 2020 05:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EQOI8T+d8gKQ2/dOWJZGivhsk/dAAdxIvvx15lVtny0=;
 b=nkgSXV2gOuBncMrl6+3qDmAAJ4sR0cdviEFX9turKav6mGUBpXp81f6hKbuJBj5J21
 N/LPrBTLq6YzT24g9KYZcIeH/otFXDRLF1bVxLD4QdMx05wn81nclYKmV/Ymr/0lvCGc
 qE+YeW2TSkoqBDMFyBUyHpLNUen/MGvUi3BE1URoNJGKnWdJZgZXgwuckoFZJuXo6fzv
 JxgI7Vipe6a5Q85l7yBv3yg/BIFoAcL1Hhp8J6e86aq7ne5qvATCGBPtB2vx5Ih0JSgX
 ipwQCUb2RNzz9+9u/prs0HS3hKdSabdM+0Oeclxlq/B+fzMfZqHdETKz8L/h71aKuvk2
 QUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EQOI8T+d8gKQ2/dOWJZGivhsk/dAAdxIvvx15lVtny0=;
 b=kt/myyXmEWcjdZf5Geq9b/mtnZ56Eyn/nBaxiJsUeKk2zqn2Tyrbr6ROFKuwBUmogk
 qE5XwO6vCZiVWZZ3bLPdCqBeA746LRHvwZlzi3YZ6MlauMK3Y9rghuF3pxVH2RStGkJK
 RFYRRzuLmkk2splEgBnpZWQLQUpN+WX5nglJ6/Rjp5G86h4W6rMZ2MuFuFcJlebnE1vC
 hPBqOtde8GwnqK2D41YqIId8JCXOfdXD5zx9X5ybmpDmAHVItMFl/T3RF7uZY1oG+fs8
 Bm8cQr6LhcJgwVAyqaUe55RAOaAGCDahYahxlELL+WQlGBZdZP4bTH3sPerBQ4fGvOqQ
 Tg1Q==
X-Gm-Message-State: AOAM532yIbqml7Vsz8Hm4A9FWpuQ8c9fhO7OB15vSFnhvXQCGM2c0gZd
 zbOy7c+cO4bBxp5epOGAQHy+zQ==
X-Google-Smtp-Source: ABdhPJwh0+cFKMPciz4Nv7GTSBxYfP4MSIi6pO0Seh9bXRp5bIKM0x+xRWrLyjLNPXBk204l11OtTA==
X-Received: by 2002:adf:a39e:: with SMTP id l30mr3882676wrb.195.1606830698299; 
 Tue, 01 Dec 2020 05:51:38 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:7c5f:5ab5:ac1f:89ce])
 by smtp.gmail.com with ESMTPSA id e3sm3281251wro.90.2020.12.01.05.51.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Dec 2020 05:51:37 -0800 (PST)
Date: Tue, 1 Dec 2020 13:51:35 +0000
From: David Brazdil <dbrazdil@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v3 19/23] kvm: arm64: Intercept host's CPU_ON SMCs
Message-ID: <20201201135135.ejgqytcxqyiwyic6@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-20-dbrazdil@google.com>
 <20201127174726.4b6azdyzn5j6qmao@bogus>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201127174726.4b6azdyzn5j6qmao@bogus>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

Hey Sudeep,

> > +static unsigned int find_cpu_id(u64 mpidr)
> > +{
> > +	unsigned int i;
> > +
> > +	/* Reject invalid MPIDRs */
> > +	if (mpidr & ~MPIDR_HWID_BITMASK)
> > +		return INVALID_CPU_ID;
> > +
> > +	for (i = 0; i < NR_CPUS; i++) {
> 
> I may not have understood the flow correctly, so just asking:

> This is just called for secondaries on boot right ? 
No, secondaries are booted before KVM is initialized. kvm_arch_init() installs
the hypervisor on each core that is online at that point. That flow does not
touch this code.

But the kernel can later power down some of those cares and then this handler
is called if it tries to power them on again. You can exercise this with:

	# echo 0 > /sys/devices/system/cpu/cpu5/online
	# echo 1 > /sys/devices/system/cpu/cpu5/online

> And the cpumasks are setup by then ? 
Cpumasks are initialized before KVM init, so yes, we could copy that
information up to EL2 and use it here. That comes down to copying `nr_cpu_ids`
because the possible set is logical IDs 0..nr_cpu_ids-1 (see smp_init_cpus()).

> Just trying to see if we can use cpu_possible_mask instead of running through
> all 256/1k/4k cpus(ofcourse based on NR_CPUS config)

I decided to keep things simple because a valid MPIDR should not need to
scan the entire array, at most the first `nr_cpu_ids` entries. An invalid MPIDR
will scan all NR_CPUS entries but that does not seem worth optimizing for.

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
