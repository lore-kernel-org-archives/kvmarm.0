Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794224228;
	b=fiPNqvs8wfb6D9u3sxo0D4YqjeMgbwnGf6LdlxYg0jN5G4YBkYAMwO1mp5kJkRK0cF/P
	 wRuG46GfrXZ4Nbk636qK0HA/x6xiMC4QKR2HIQ+QAvBJIreRzud8v9foyZcmkK9E8JQlU
	 hWS16Al8aB3jaJV3JXNxWGwTwc0iNzR+UlyLje3oLfjmdJsKogAMfWp60G6Z49RHDI10i
	 zsg6tMCbHXeU2neHLiGox5b4PcVuZUAo8s8OZShqSD5Nja55AwePIIC5Eu05blekozEmW
	 MzOOr/eZp6gdQzoT49nOlmpBPhpyqOYjbNZF8cg9QgkckcXWqU74IJAIyTiphLmvlpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224228;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=udQqDn88X0b3LP4L0/q7EU+GGttEjcPesqMGbO00iBE=;
	b=c2DssqYjGW/olMnn7pjPvJle8Sefc8ORHz1uTq+H/heN0L2hnB7iCek6sy212YG+JNOV
	 neC0jriAlbMHuRrBuVOCUX0jg1f0Y8NcxTPJ9Z124EIG/eIGwCDek9e36m+Kr5AZKC7qY
	 B1ky2T5e44U4b+Ol8HCs0dpbeMvXawH7XnuS7p+LLH+CgAIygD5F4t8E8wroWHjcoTqla
	 8rdKMi4BiKaDey3H/7UkFXSyDC2ss9DZPYj5sFBBElfLshLCUrHpp1ocg51gYteBOocz3
	 jvHRU8wFNi8yLtu13bEz7bwvzh4jLYEnYfKQQWkwGfzJH0xvtPP28MZW9tl75sq+/NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cD92+wZe;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A988606D807
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 11:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A988606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cD92+wZe
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a206f0b95bso30805e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 03:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794224226; x=1794829026; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=udQqDn88X0b3LP4L0/q7EU+GGttEjcPesqMGbO00iBE=;
        b=cD92+wZe25pBoZwDARzunHYSoV8ThYNdjrPVyCj3G4mtUWlm0p3myAu1aKZ2DTKMZu
         IbMKWneeI0HMR9imPYbwXXRKD/u4kGFDVInhOK80GuwWlBqAYhImCqnVnxr76KnJ/cuT
         XJ49ZQAiJnv8h9djC8h5YZENvyY8zL5Q6/h6OhadEb1tCDh5whIBg/nApEz5csx5qNv9
         YkUp0GHBfeQ/qc/2nxFI3J4F6qSduakMHfdAcfYhx7MCPn3hio9h/hIAXQt5xzMhGah0
         P8k3GJs8qAWMArHDWBphSN6XfGQ9lGliD5yA5dUagcpgOZvJzpl3ECBL/0sEAiqw0Yb1
         /KeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794224226; x=1794829026;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=udQqDn88X0b3LP4L0/q7EU+GGttEjcPesqMGbO00iBE=;
        b=CxPVwKWtdUqKWjKub01N1XOxw5sMsWWCqoQyZFKFJFBxlk9ZAkBrZCHL0SPzPR8AhC
         jkQTyO/qiTvLRa+bUkbnaRSvCEhGu7dZ++2uXqlPfyI7j63RWO9C+b1ZACeex7TC8x3v
         czVV52AU8IkkRXmmukrK2+pdVXrXYyxuhXbkiFvZpb1PU3kdLsoWEQYtU2WDkmjHIJiA
         foOtxNPmuz6nOJDbQCZvOtV5w59vdP1Nw84McBNoOEsecaf3vkByHE7M/fHX2CEpkiNa
         nhXeRStBZ49+ahBVPYgm3ga6vBhZciboRGHzEgjUgRVfh9sKH73lhzWe5faXJvHMPKdk
         ixYQ==
X-Forwarded-Encrypted: i=1; AL+hErESCHT+AXIgkL+SW/rz1BMmobhjSInL65EamI8aVwN1QVuV7DBhO66mHS+BWQepWyzOHKqs830=@lists.linux.dev
X-Gm-Message-State: APuU4Z++sSgmEaHBXV6kOXsLkOqzPJ+QUiauu10vDNbKNkr3mCzuXkXS
	PAv4YZ1qS23Y15PwBMRv9VmuVlmHIdzQLzVtsxl8TzDAl/NGfaKrcnc69s5MetP1HA==
X-Gm-Gg: AYBFou2yP6lKPs07zS9JX+Vd80XGO6WNz81JJq20pvcX6r4+ocfx47oyNF9iaCWk8IR
	4Apnzkx7sd4hAa1Mo47/qJhFWdUf/7xap08xYjxIXIav/rcvjokod9ImCVsSSmG7n5+c2wEycED
	zCJ3PAyzmeotDQVS36cvu+7gVrcT2pocnNn2ak9r3g8e7F4O/hTTMe1e8pX5MrpU2mDZrOmdJSa
	YmiaqM75tzCi+fQtxGqI9ggntM+keXUB3QgV5MKTAXkoDV0F5A68pHFLMNG87SaPU+c3T4AZJTi
	aL7p274Wmhv+oTHqD4HDghNpINhYjXEgbUZPN9s+h+/bbkQ0D9jSsTQqMHF6eYdTqcVTKAxMQu1
	SPBD3bJXwYaExcognBZWN7LXAjG3gVN1Ms4KovMJNV6bQKIG0RCh3cDyBnhazMecLDvlov0GyK5
	MgTRO9B2Y3QaEGindubpqyi6YUeOaF0ycPTTpJRP/Ky1lw73JcewqzXWgXN8Hi1BjdevzgRA2rQ
	RJelW1RhF31ztfNQIP/HWz1c9HZwsRGfnkM9Hsre+Jx0d4h8pWJlDwBpc7EimBQmyilH/+gyQF9
	yEEGNk7vRz2z3C22g1kxpGBuiWlvVo6Q1vud7EG0BNzGCOgHxPlL3H1h1cWZqhe8pockc80a//L
	2D9dmIPpk78/624o=
X-Received: by 2002:a05:600c:4c06:b0:4a1:eb02:37c with SMTP id 5b1f17b1804b1-4b82056727fmr1353855e9.6.1794224225622;
        Mon, 09 Nov 2026 03:37:05 -0800 (PST)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b90619bbd2sm134824845e9.1.2026.11.09.03.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:37:04 -0800 (PST)
Date: Mon, 9 Nov 2026 11:37:00 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 14/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
Message-ID: <avGwXHSlo3Zj6Fpz@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-15-smostafa@google.com>
 <au00hT6fsY10WJ9J@nvidia.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au00hT6fsY10WJ9J@nvidia.com>

On Thu, Nov 05, 2026 at 05:59:33PM -0800, Nicolin Chen wrote:
> One more thing:
> 
> On Thu, Oct 15, 2026 at 08:08:45PM +0000, Mostafa Saleh wrote:
> > +/*
> > + * The kernel part of the driver allocates and zeroes the shadow cmdq. Take
> > + * ownership of it and program it into the hardware.
> > + */
> > +static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	size_t cmdq_nr_pages;
> > +	int ret;
> > +
> > +	smmu->cmdq.llq.max_n_shift = min(smmu->cmdq.llq.max_n_shift, smmu->cmdq_max_shift);
> 
> Given this is the cmdq used to run commands eventually..
> 
> > +static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	u32 shift = smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
> > +
> > +	smmu->cmdq_host.llq.max_n_shift = min(shift, smmu->cmdq_max_shift);
> 
> .. should this be min(shift, smmu->cmdq.llq.max_n_shift)?
> 
> Otherwise, a buggy guest SW might setup a larger queue and number
> of commands?

Makes sense, as in patch#16, it caps the host view in the emulated IDR1:
			val = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
			val &= ~IDR1_CMDQS;
			val |= FIELD_PREP(IDR1_CMDQS, smmu->cmdq.llq.max_n_shift);
Thanks,
Mostafa

> 
> Nicolin
