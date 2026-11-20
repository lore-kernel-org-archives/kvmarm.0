Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795187508;
	b=adkpUHjDljw/5nV8REd7+HI3oV6AtIWeGXFvzss2GTA4VBfKzR7Nfj5hL6WBlwC+hI7e
	 0mqmVTyGsZ3xkxQ3Lt9ttfDCB78m3HhDCvWM4k0VtqkmbzsUDeTN0hbojKgNCIrQi/Dch
	 J8eDlRhSU8qdlVvkwpLCQRNPGIBaJrpCX5j1egkr+m398/ddpC0/wZw68iOpPieOp42/E
	 gphhit34CQZk6L0cJolFNhWoHaOVc2SL9OG8gTygZp83DihrFfAUoeBREGUeFmUS6GtmO
	 9TkJMEBixaVBSW2mPC1/3DLv6/UsT7HqDvmLBNQxbnvv87WEBe7fbDQD50zIAX0KMaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795187508;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=9L5DYVZJmCTJDhX0/RtB0BzmznmCbVTr+mYGMw33Evs=;
	b=nI3OcEi7Ub8D1giGGQ1qJo197wFQPwjvYFyMZk4S/foKbtvTq/qTSfq8yDb8OEHVPEcb
	 ulTGD0DLbcdSBDZlGYLpN3unG/iuq8mpI3mXZfxdykVu5+Zzlbe13DT5YR64r/jmUjQg6
	 BiBO/OoqM7Aa329n9m+lYfJ+2Xdar9bc76rswxfQ+7TEqpcrteCfOHoGRnLpEw7YDiJQL
	 SopQdu+2LuX/a3P9XV4PSBdodooZChC8xWNyXWo3EmR/XSd6GDksrkQTPrl44pU/OR5Hn
	 bXu11KNJa+17r+z9zTUgHOfxaMkcFdXuRLZMnmse16sTHgUMOAM+UH4woBIL71BuZpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stefion.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C2FF5CiZ;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819B1606A333
	for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 15:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 819B1606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stefion.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C2FF5CiZ
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c50547b4992so84284666b.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 07:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795187507; x=1795792307; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9L5DYVZJmCTJDhX0/RtB0BzmznmCbVTr+mYGMw33Evs=;
        b=C2FF5CiZLBnM56/aQavu5yZ/uwIEIyUt8pvVZduiYjW5jgtzesb6mGkIM4ghNbvIlL
         kb/+t5lVVGMvV8mEYktLyL7i40WyUzohVUGG9ksgAorvEFPRXabLoQfulSANKyCwAGTo
         ATO5d0aBRtYrTwanK7VarhRXUmSZ88i30MLbPduf/lEI0j03iPMXHu4fupCphnxSEyH5
         BZ0u65Svgnf7nKDwnIC48N9l0teExWqnnr4DXxSMOGFmA/GPU9E3A8pAQBrQdRKDTL6U
         qDWKRz2iXzvEHY8mH+JH/sxzOYLiubr399iQxA0rcgfNol/eXoSgvKV5N8ISxFYQfKCV
         uxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795187507; x=1795792307;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9L5DYVZJmCTJDhX0/RtB0BzmznmCbVTr+mYGMw33Evs=;
        b=GOQyLUtAW/VzF5ZqmfZriG+p6ffv/8lmWN09x4EOXowvKdZcfQCpM3iwWpx/srt3P/
         nLflaEwme+p+jQjuM+wtIvkyMbI7itZX647jsRO9486/BxX6b8J48ZaMQgC0gbyy71Zq
         9mGpuMD7GqebPVMRdyF8VdM9KCoa+g4gB1bOoou+hnLrJdk1PQikLhQrohJ3pexO9vhv
         gEbPuN+Zxgce/wjvDEwScIDxE/f1KsG79L+9gGYOX4FVu6nac0rvc6MGN/gmXQxq+W/h
         77/WZa4SHrtvBJ2/v/eKhwEiB6sMKqDC6uASRoOtDUjr6KFuTKMLWxTWMxPc9iZNWQWV
         hwiA==
X-Forwarded-Encrypted: i=1; AL+hErGjgaxFbqex6JDeSWni2jMH3iby+wh3F6rniFTQWaytmUHfOWOwt+kqfeCaB2gLVNQc9FPLVzA=@lists.linux.dev
X-Gm-Message-State: APuU4Z8Y3TTk83rDF3JcRpgQR9Dih9WLnGvNka2az58VC7MdCYgaz2FF
	T5Hv1Gmbswq+EMCM4kr2/gksVJ7QV80h+I+eHZnv4WAjvaOCrOd/99mu1Vr4cPJvTRwa6dYcEZl
	11iBPVm8H9Q==
X-Received: from ejnw20.prod.google.com ([2002:a17:906:52d4:b0:c46:7c51:47a0])
 (user=stefion job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:69ca:b0:c50:f024:5219
 with SMTP id a640c23a62f3a-c513ab48468mr252861866b.40.1795187506339; Fri, 20
 Nov 2026 07:11:46 -0800 (PST)
Date: Fri, 20 Nov 2026 15:11:14 +0000
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
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120151114.3708208-1-stefion@google.com>
Subject: Re: [PATCH v2 00/19] KVM: arm64: selftests: Tests for protected VMs
From: "=?UTF-8?q?=C8=98tefania=20Ion?=" <stefion@google.com>
To: fuad.tabba@linux.dev
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com, 
	qperret@google.com, seanjc@google.com, seiden@linux.ibm.com, shuah@kernel.org, 
	suzuki.poulose@arm.com, tabba@google.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com, 
	"=?UTF-8?q?=C8=98tefania=20Ion?=" <stefion@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Fuad,

Tested this series on top of v7.4-rc1 under QEMU TCG (-M virt,
virtualization=3Don,gic-version=3D3 -cpu max -smp 4), booted with
kvm-arm.mode=3Dprotected (protected hVHE mode).

- All pkvm_* selftests pass. The only skips are the self-hosted debug
  (breakpoint, watchpoint, single-step) and SVE cases, which pKVM
  doesn't expose to protected guests.
- pkvm_id_regs fails with patch 1 reverted and passes with it applied.
- Each patch builds individually.

Tested-by: =C8=98tefania Ion <stefion@google.com>

Thanks,
=C8=98tefania
