Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427352;
	b=1aFWI7MOzz8kC+NeYin86+i7uHMu1Q69k5+7RsTsZhmAtm0lQFR9KCPQgee2DqXYQgu/
	 thxTuyjorPCuljxAfGecYcT6t9VeVm7I5diCFTILCoxW5LTf2CyRWKsBl6d8siWfPAIe1
	 oVv2Jd5XPMzkncnr9eMDYGhqLiDsAhQFbDtou5nHnm/XOnQmCmz71AiGHAPTpekbRbOcN
	 dmwzVG52fslHWP5GacSqmiaJW9x+EKho2TJ4Smq319LoEeY3fm3obbxR2KVCD9fj6OfXt
	 MotYYbv/FzBhPUxHGPTRYFODCdmOq4DHFzxb6d1gptxOHZe04MTSi0oIzmtTMMdgFIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427352;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=5g6rxDcE+XSPvTO4IYmwgvIS3I7HcVTmR8Q7VnCTKgE=;
	b=HbbpBR9nc3umdNC2Ejux7OfikDDNneBtNVQOuVpisCfOwquMzofmHvEWBnpu69q1fqJp
	 u7Jjp8iX6bZR19XrPLXK0UMTwcgT2ZhTJUiAuHXylw0mGzKJw+eJMF2SuWqUTaSkYm19G
	 tz0hNiNdFoGSsS/nqSPnyfV9EvuNApApyCbQLt5iPZJkpIHpvjnCQ7x08LyAyx2lsJk2G
	 G/HlHLshkFe7PR5X2oh4MnxzbriUYgvAiduOemcSwqj/oNbYJtHoM1ldSghJtvBLsi/Gl
	 zlwGrU4D/KzhCDAfPhKU2FksvW8ky4jJrQUwDNJ3HoDFvXJAsAuwweZ0wOahq/7qx5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--mmol.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qFrbSlIk;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8AD606A31F
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 09:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E8AD606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mmol.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qFrbSlIk
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c5101fd59e3so264684466b.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 01:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795427351; x=1796032151; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5g6rxDcE+XSPvTO4IYmwgvIS3I7HcVTmR8Q7VnCTKgE=;
        b=qFrbSlIkyGfUln+wkWxvAa+e8jGJD69QJ4Hepm6WBsMD/+6QsnD9LSUnj9kTyPKfFe
         NNKdEHPxnhUjiB9SxUQt3bB/dp5qJl4K4ZMs7+ORF7NlMOG9fUbb5z4hf9P7MlO41T/Y
         GB6CI07Uk77vigHlE3mR+YHITPWB/w0NSj93FAXji5HyEq5MmfdNCCDDrOaCJTBIpmH6
         V20iAeRtTMS+WD9kkfGruUSkPu70mc3kAQf2sLMyBOZ2Fc8BVluvVbQZNDGmijwCSyvB
         LK2eg5VygnQP2V6myyXXQSljnBys3mDGugccX1a/F/fEg9uZhH+94LGDXSA+ePSefMZT
         DA0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795427351; x=1796032151;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5g6rxDcE+XSPvTO4IYmwgvIS3I7HcVTmR8Q7VnCTKgE=;
        b=FravoVWpg8IcGJM3o1C4vaOm3uFfepzT8PiPo4psxGdabZq2vKXGsPosmA7OixOdOh
         KDgR3IZC+2uVuVXz6rbGajvCmws+T6HiPp8KmEmlyTq4XmzirKrj7L+KhcEh0+uELQDl
         CP1vfpYqWLc3z9oFKqywvpA5VmzdN0FO7gjQ4uMPKxQZNsEEu7WnexahKdyV++ztNaCE
         pD/sd/FDpxOQj1lSpmvdOhvRWZSEczL81raW04edzre5yKGlwvmgk/3dG1QpmaeRmc4Z
         Nz5Z0d34NFeAvbQVnCOBaOzEt6j91qaMZoDV3+LfHd1odnuEP4Kc3i782RJpMcvcBILF
         UtkA==
X-Forwarded-Encrypted: i=1; AL+hErHqqsTkh0HbSvlqQU6xXvmsWtgDqj+3jBn2vleQLhfGzkCucH9GS6KRQNJ2FKltks/olXE1Q+I=@lists.linux.dev
X-Gm-Message-State: APuU4Z+CQ50n5LfGdG6F67JAaASvo4xCSJ/+yuuUy1e6OkV2lrSNljD/
	u7AC8qZlXmR9enpzXIWPGKZF4ndUYCT0dVZ2oYegVgXPD/21Ko9PIbT9aj3kC9cSMgsJ5QaOcw=
	=
X-Received: from edtg7.prod.google.com ([2002:aa7:c847:0:b0:6b8:98f6:dcc5])
 (user=mmol job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:46d3:b0:6b6:f429:4802
 with SMTP id 4fb4d7f45d1cf-6ba37ea3508mr5728784a12.25.1795427350480; Mon, 23
 Nov 2026 01:49:10 -0800 (PST)
Date: Mon, 23 Nov 2026 09:48:52 +0000
In-Reply-To: <20261109084854.840576-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261109084854.840576-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261123094852.2435494-1-mmol@google.com>
Subject: Re: [PATCH v2 00/19] KVM: arm64: selftests: Tests for protected VMs
From: Mihai Moldovanu <mmol@google.com>
To: fuad.tabba@linux.dev
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com, 
	qperret@google.com, seanjc@google.com, seiden@linux.ibm.com, shuah@kernel.org, 
	suzuki.poulose@arm.com, tabba@google.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com, Mihai Moldovanu <mmol@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Fuad,

I have tested this series based on v7.4-rc1 in QEMU
with gic-version=3, -cpu max, pauth=off, -smp 4, -m 8G

All pkvm_* selftests pass. I confirmed that the skips you mentioned are
features that pKVM doesn't expose to protected guests.
pkvm_id_regs fails with patch 1 reverted and passes with it applied.
Each patch builds individually (tested with git rebase --exec).

Tested-by: Mihai Moldovanu <mmol@google.com>

Thanks,
Mihai
