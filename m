Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF044432BFE
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783354798; cv=none; b=cFTi7RELWk4quKpqcMQo8ZHnXGcj3XDlMXskQmDipdKBvV/osmR/U/1U6hcs+J4AGlsiJGcnDeTPBcQPm/N8JEcsUjyNXhYEjc7XXtvhyvX/UAfFMZndJLPKoZYwS9kxu42dfBy+mij5MK54/nEtRWVO5jTHAKYX7rSlAwaiwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783354798; c=relaxed/simple;
	bh=yjGhQMbHDenpraLHixtOwqZoPtKGdjSXhEbErZkn3Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qffdUc2PMaldrbMTKfUH/+9wX1Az0hQRJFupTK5qJySVEyoTlGHZUalel3uZVNwVG0fSvDgEZVgujeNfvCpvHL/2t9udsQqMo3k6w6bADWQUHoc1kakOhqXymjxOXZvLpm6lRUS1JetEHce0PvUSWcvp2+XSbUFkwQ8A4yCcRoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RobDKBWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RobDKBWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCEE1F00A3D;
	Mon,  6 Jul 2026 16:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783354797;
	bh=RDwYh1YeuGi/b0Zy7yz3GHb7NjrEdb3AENsC67E47M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RobDKBWayUG+X/Ilh3SHUd4xyFMcP+n++3qa72I/4xv1dWQC486U5r1qRJVl19lRe
	 AxK/UZvOYR//foEoZobPJk+KTDHVgKFrS9JdXGU0nLENKiJ2UUTg2jU9wGqtl89QGY
	 pxraSevz8cSLuNdCcsiveuHeygnWWQSpm7Azw7S0iqP0zq1Klx402CWQAHERhI+3xU
	 8mnNmoyrGAWXIQLH91iUEwRXlTNHoHCO52+uKkE5XAuuWBkABLpQyYvVkFBi3e6vfn
	 OTryaSu85BVGZEjUC4zq0w7DUeNpht0qgj6kFdTzzpLWMbRmutd4MEq5914qADaxQG
	 RPIXg7zVf1N8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wgm31-00000002249-2oy6;
	Mon, 06 Jul 2026 16:19:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes for S2 permission relaxation
Date: Mon,  6 Jul 2026 17:19:52 +0100
Message-ID: <178335476041.1423186.1281496157054528117.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701231620.3300204-1-oupton@kernel.org>
References: <20260701231620.3300204-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, weilin.chang@arm.com, seiden@linux.ibm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 01 Jul 2026 16:16:18 -0700, Oliver Upton wrote:
> Couple of small fixes for S2 permission relaxation.
> 
> The first patch looks a bit worse than it actually is, potentially
> consuming an uninitialized stack variable as a TLBI TTL hint in the
> event of a race to update the PTE. However, if the bad TTL value results
> in the stale TLB entry remaining valid, the vCPU will just fault again
> and (hopefully) avoid the race.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Ensure level is always initialized when relaxing perms
      commit: 100baf0184896f859290a684f864b8200d8ac872
[2/2] KVM: arm64: Only update XN attr when requested during S2 relaxation
      commit: f35c08c092505f3a83ce097d94fe51eb8bc9c1b5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


