Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792876995;
	b=1TcRppJajXjLnAn0NGer88HIiaPq3Ua7MEHkUvOQdLOJw9bfdGNJXbJ/2dMdf8kyNqW/
	 4iat5UZ61JW2b/mX/ZSZuSLlaCGodmjxJIqA5f4jKnU1xNtcoqMlEgEVbBr4Ras+Ig0iz
	 OYkgj2C+sXjZgXKnHeDfzSX840fXj7bw9Q0xCJbiHucW2dcWhsNY0OnWoEbQWAH1I1L7T
	 CORkqEH6fin+FGLXf5hppL19EGVi8bDkNJkt0DHYceS7ZhQd2o/74+VDYQaufrVRSh95D
	 ppjjeL49JZsUhhvuQ+GO/50aYETy8s0H7xKbKqouqG8U9dQaPpz6Qrb7Muc/q18n8sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792876995;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/uDSBSON0zRSqoCF+kBzR4qoVmokC3Xn3ipHg55DqZs=;
	b=dpel35uWefC9mTTBMWqDSud3FN4R0OgPnP8hghe0ZN+oCgBtCzWFCn/potN1sTotoHSd
	 YKtY/WtXopUQDpCecXTk6LGmErTspvOcsiLZALZ139QUfp19W9v8AFsoZn/4Lz94LiRa8
	 G3ZffXIXLzdMdNrtQa/fm9oRxhQiG4wxuoC2Xw9UqNtgS4ofymQ8iQ4PDdCLTbGqFHGb5
	 x0pMTubd4i1gz+Lp98oZH7IdYII4TPrpZ40+mtoUnmi+wDnG7SBFHqCS+R7nKrNS5q8HF
	 v/gpkrRe1k5dmkzvr1LM1ASJrVODffX9NYImbvgl8TjLjgQjwtn5tuRQTZBgsHtaRbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CRf2l+FD;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DBF606A31A
	for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 21:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6DBF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CRf2l+FD
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so8665745e9.2
        for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 14:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792876993; x=1793481793; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/uDSBSON0zRSqoCF+kBzR4qoVmokC3Xn3ipHg55DqZs=;
        b=CRf2l+FDeWRsEQqLqqjAyAu8Yp6cK0Xz1iRb7vDndipdWj7EbOu9o+pwpNLC26CC0r
         4ZQrzJVcV4Wyb2/PEe1U45Xvn6OF1telCWHQq7NHHN1qxcGO4eteDTppC41P7FXcyX/E
         KLsF70A2RW6OP/bpBg1brlDKLJ635DcF41IrsLUU21/x6tdBCftnIOKR9048Oz8t8oKE
         1sF24DUNBaL7SMQHHXX+uhGVXYsgO5eudibqZscSCUEUUtemApRI35qprapdLJgePtRX
         FMv4h6+ZSkwYa/du+6IPRKEaKKKZWOSdWHCSmZXSwP0ksfj7ElBxN4vcPP0UTFJv9wfp
         TRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792876993; x=1793481793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/uDSBSON0zRSqoCF+kBzR4qoVmokC3Xn3ipHg55DqZs=;
        b=yICBmWpfzbIQUxWDlISKJo4/74TxprbeiFORiTOKR1kz+/76J3xrn92VY05jSbJKD1
         9s6C6mtwjdxsFFyNkEfP0aR9ISzBWQgPeSjRtbGlA3NmmFSZwLwtkuV0hSpQHuEnqrpB
         KHGJZMzm2phaula1qJQarqsW4iaMG/dkaf2GgpVgyWoyUDlNeHH/5OJ1tOyMDsS8FZ8q
         C0M3faqvRnAs+XU2WCoCrYhlxeyIDPGef8xa6bNsw9/igv831Xo6R7eRxeMKHHUAG9PU
         Fynka6Gsbny1loK1y2CeFDW1Getet4tCCMELki+8cbDOCZQ+HPq5AulUYv8mTNHtolbk
         v3bw==
X-Forwarded-Encrypted: i=1; AKwUvBxTRdXOfzM7BZyQLYmr096nKvnGCGCZdp8wI5xqltNx3vdGXmP2NOjGTQWjCVlz8QCuNuSDRLA=@lists.linux.dev
X-Gm-Message-State: AFq9FYImln/zrV45A144MeCNTCtSJH3CJH9zS1LkJyGC+DmDACPQjMQh
	RXS+TJXQxdCHHipeaWtCFbWh4tuVjfDQ7LV9XPVk7Y77Y5MUCaxqp1Nd
X-Gm-Gg: AYBFou3eGgNXWN94+B3iAd9Hs2xAp3bHdkKKKN75U9/y5skprcfW3O8dFCfdt/LJmBy
	w3hG0HSQtcOaO1XoqXACo6Mnzeil/az3v3un/Zlp32WqJW3RZfCJZOu0l1TyfYOQ/RObbTdmF0S
	fWcBeziR9gOTZ6m7zfFpZAufSini1RP4Wa1eCKWsw67rviHPYoEmr0VlDjOCrlm2PG/11kAy4M8
	5zHbk4vIkx9sjhrz2xtPRQbEuuGRadcIgQsQVb1XljC9o7RvzjwKKelui47AIez+IahN24OH2lX
	NR3bIGM6/FOCHIC9Eq6l6jdBY5XChKuF7uxLzUb5cbsoe5HfJ+DmzqUvrpTQksu7kV2kF3uL8EW
	MZitkjvffoIPknxJR38kgEJwX7Z0KSPLCxifuTYi/WdSUgbuya+JAJE+IEA9AiCteJLxuKRD9v0
	HwRxdJNJt7DYRCl8yGM7m4wzAv10WWz+CpLGnLkyaLJagzNKJN7OBlDGPyYJzoG5Ro0vPGNtm4r
	q8xXj9EacOoOqCGPkkNtdY5BRKo6ow80DVD3L32xP9zvZYxte2TnZmT4aAIMcGg6Z8pwiXu4uGY
	CnG57A==
X-Received: by 2002:a05:600c:6095:b0:4a1:f7f4:7cf1 with SMTP id 5b1f17b1804b1-4a35ac8bf3amr39663215e9.11.1792876992941;
        Sat, 24 Oct 2026 14:23:12 -0700 (PDT)
Received: from ASHA ([2001:630:3c1:164:1a66:daff:fe85:4026])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a359f3e00asm147825395e9.0.2026.10.24.14.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 14:23:11 -0700 (PDT)
From: Amir Noohi <amirmnoohi@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Igor Velkov <iav@iav.lv>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] genirq, KVM: arm64: Avoid the irq descriptor lock on vCPU load
Date: Sat, 24 Oct 2026 21:23:04 +0000
Message-ID: <20261024212304.2620845-1-amirmnoohi@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <87tsmb8gdv.wl-maz@kernel.org>
References: <20261024022450.629980-1-amirmnoohi@gmail.com> <87tsmb8gdv.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Sat, 24 Oct 2026 12:52:44 +0100, Marc Zyngier <maz@kernel.org> wrote:
> Looking at the test case, this really isn't a representative or
> realistic workload.  This is a contrived setup that has trapping to
> userspace as its only purpose.
>
> I'm not saying that this is useless observation. But it is not
> something that represents something exacerbated by "real" VMs.

Fair enough. I checked with real Linux guests running hackbench on the
same Altra (kvmtool, in-kernel GICv3). With one vCPU per CPU, and in
lighter hackbench runs, it makes no measurable difference, but it does
once busy vCPUs share CPUs.

With four 31-vCPU VMs on 31 CPUs (124 vCPUs), all running
"hackbench -g 31 -f 20 -l 2000", each VM takes 76.5s on mainline and
60.4s with the series, so 21% less time (8 runs per kernel, no
overlap). In a profiled run irq_set_irqchip_state() was called ~2.4M
times/s and 47% of those calls hit contention. With the series the
contention on that path drops to ~7 per second.

So the case that matters is overcommitted hosts with busy vCPUs. I'll
make that the main justification in v2 instead of the exit-to-userspace
test.

Thanks,
Amir
