Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1053F4D1780
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617647; cv=none; b=jplKry0j3cefxrdctinM1HR7NKlYx2++e0D2iwsTgSRf7G2QJ3sgJAhy0YQRTX4m7/yczYCNrjoCIF0tfJ4VIdq26RV7vXS9JazcZmdrfDKjDm1UcSeKS6os6B9JipYPyX0pnE1yeIGSvbp8/dxmVpeXDPTxs4SVcoPwTO0g+s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617647; c=relaxed/simple;
	bh=XyuHMcU9BbS4rZO3qSAgRdBv7BTX7Z9PJ3I+SxV2FeE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sTrZHvYnroNbg/JP3WYvp9XLfLoJGPSRXVVjgQ9zMZe+QrCtuGdpuLyo3WfrOceoHOK2TS8bMqkdw8BLJqVlhiQIUevpAAcQUUkl7Kt3Aefit0jwzmqVqHVAocFveEA0tyXZpFnOuVN4DFGN4bGaVbIIv5VmPXDv59fjahdpjR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rG+cYlCp; arc=none smtp.client-ip=95.215.58.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rG+cYlCp"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XyuHMcU9BbS4rZO3qSAgRdBv7BTX7Z9PJ3I+SxV2FeE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790617639; v=1; x=1791222439;
 b=rG+cYlCpWA7YUysgTp+nJZS8DB0k3hg004QgeE6o77dfXykYd0WV2i9ocLruRHgghTEGY7Tn
 baTMLQXUYdTh2X2O1hxTJ7p8/gwUoB2Tlcdc4/xuS+zAXSv/9PQDTgKNCtCZgnyZZdMyztzkXuM
 i/2v3ZqOPBdsQR407E0kjFRA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2768ea4e46ec6903;
	Mon, 28 Sep 2026 17:47:19 +0000
X-Mizu-Trace-ID: 2768ea4e46ec6903
X-Migadu-Flow: FLOW_OUT
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6ab0140ecb2so1205a12.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 10:47:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx3i7ej/0ylChSEW0nP3x7u/KIWpqYzPx/YPYNUgBWSDbA77/Dr7QrUMao/h+9Qs0gqJIdVaHg=@lists.linux.dev
X-Gm-Message-State: AFq9FYJsixG+CZieP4Ryt+E6n0CJ95j41IaoVzx9zv+BWASI7GDIoYme
	6RPRipSZjSISB01NM5q5+0uwI8sABHT74RIPwaDxO+y824/LXmW8lVmTcgbR8A1BZLnrPAcR182
	Avr7kfgQU9OoPAH6hdpNI4e2/6UrYPrpdZgbaHgg5
X-Received: by 2002:aa7:ca57:0:b0:6a6:967c:3186 with SMTP id
 4fb4d7f45d1cf-6ab01ed939fmr94944a12.2.1790617638152; Mon, 28 Sep 2026
 10:47:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
 <20260928152507.2116110-5-fuad.tabba@linux.dev> <arqaNHGzVfMpVha5@kernel.org>
In-Reply-To: <arqaNHGzVfMpVha5@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 28 Sep 2026 18:46:40 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz=sKCZpQzLkMaks0o5hR-R=ACKVinPgwzAiyVUubirxA@mail.gmail.com>
X-Gm-Features: AclHuK-Tq_Aet2hB71IGOYbMLUlrt7UHvVGW8T4ukejDyUoOFxO6nR4iiKf3Ohs
Message-ID: <CA+EHjTz=sKCZpQzLkMaks0o5hR-R=ACKVinPgwzAiyVUubirxA@mail.gmail.com>
Subject: Re: [PATCH v1 04/10] KVM: arm64: nv: Return a failed stage-2
 descriptor read as a fault
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Karl Mehltretter <kmehltretter@gmail.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Mon, 28 Sep 2026 17:47:48 +0100, Oliver Upton <oupton@kernel.org> wrote:
[...]
> Hmm. Rather than fixing these things individually, I'd prefer aligning return
> codes between the S1 and S2 walks. I agree with the approach; negative
> return codes should be reserved for host-visible failure reasons whereas
> everything guest visible gets communicated through s1_walk_result /
> kvm_s2_trans.

Makes sense. I'll bring the S1 walk in line with that in the respin,
with the Data Abort change on top.

Cheers,
/fuad
