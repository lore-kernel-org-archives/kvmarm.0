Received: from mta1.migadu.com (out-112.mta1.migadu.com [95.215.58.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF334078FA
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 06:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791355561; cv=none; b=Yb6az1J798LqcIbd965NX/6UhvPH9unXuJYTQfbGfOsXq0rSuH690B2jkh5T+eDYx/QCPKDKNnZr/TvIxrkHwNcR1ghzqAB+F88TAavxdnc719vu8ROZ7Hl8EktPXGhQSw/1OHVtAkRbkQFJhmS0A67oHm9OtpT0v6irOz+CuGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791355561; c=relaxed/simple;
	bh=VPGN+t64IBvFdkHANdn3m+qys3d57vxK5dztlkdO85Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cjCMP2s32BVYMVkRIiTWpoWqRU+leTtV8alVUqTOruI3HAq4nbf9grD2sGBVWwSyUsFuFMHT+R6M2Y4UZAIUaX7MNHblrTjXLwt50k+kcRPIXQ/sCWEfRwn0a027SlA+ULc6zNmeYh2Xi43MhNhvT6epVnJvm3f26iAK7zREkNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iqsxkDHw; arc=none smtp.client-ip=95.215.58.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iqsxkDHw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=VPGN+t64IBvFdkHANdn3m+qys3d57vxK5dztlkdO85Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791355557; v=1; x=1791960357;
 b=iqsxkDHw7Oy0uiG4zbpuJ13yrch3bospxGtS30Ct+KQgTpmZLToyblyf42MeZou7IJ8nLE38
 k+4M3cFQ8Brf9d+fPGDkl9MY6vPU0A8rjcNlSN98CsIkkcQAjx49jvRvZcZHxVqxKlrbCK2c7Pq
 1P9uhXHLA+U4T5bRD3seWAq0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0101756ea02aee22;
	Wed, 07 Oct 2026 03:22:49 +0000
X-Mizu-Trace-ID: 0101756ea02aee22
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so4611e87.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 20:22:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxoorlir8Vi1X5ZS+lVBX5ZMw8IFBwQvoa+smGVoDssVsyoeQvHjycN0tthsAUIYSXuz1//MxA=@lists.linux.dev
X-Gm-Message-State: AFq9FYIx1Azb9SsFlRYY+0TY1NSpUQMcXGHq0GAA1C0KvG5a18ykAXg/
	yEdZ7f/94uIPRcHSmVyhgOn54ZHFh3XamfUbAJd5Eo9JR1rw7qI12At7Gn2shpsWzURo4hbCor4
	K4KGjAShmypsZbCu/8ranVCTppGnHnZB6Z8Su0vDt
X-Received: by 2002:a05:6512:33d3:b0:5bb:ff6f:b4bd with SMTP id
 2adb3069b0e04-5bcca66e395mr244039e87.14.1791343364546; Tue, 06 Oct 2026
 20:22:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260917162020.1612577-1-fuad.tabba@linux.dev>
In-Reply-To: <20260917162020.1612577-1-fuad.tabba@linux.dev>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 7 Oct 2026 05:22:07 +0200
X-Gmail-Original-Message-ID: <CA+EHjTwDaaPCN0=pGJ89bGA0N5URZAK+eqTokvkHmft4qAtCmQ@mail.gmail.com>
X-Gm-Features: AclHuK-0Udk3UkUYFCVMAQPB6nZiw27oXOAJk7rq0N4zkCuJTUndM-riXQ1es2E
Message-ID: <CA+EHjTwDaaPCN0=pGJ89bGA0N5URZAK+eqTokvkHmft4qAtCmQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Update GITS_CTLR.Enabled under its_lock
To: Oliver Upton <oupton@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, Eric Auger <eauger@redhat.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Will Deacon <will@kernel.org>, Sascha Bischoff <sascha.bischoff@arm.com>, 
	Sebastian Ene <sebastianene@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

Gentle ping on this one, the GITS_CTLR half of Hyunwoo's translation cache race.

Cheers,
/fuad
