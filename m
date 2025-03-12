Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50881EFFA2
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 21:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813501; cv=none; b=YFCAy6MdA4twIj3LxPizaFWdBlsdPYbitM/udoGksOD03D1j1NeMsJ53/+ik9ncrtkLfDyiiMvSGhGITh8kvE+EnVosM8g9PQbXUKQsINiDR5PrN8KsoZ7MsmLAMhmamDEDbhLlMvpZFvqDNw51Yr13vVaAN/NOeZ7dvYZ0a6Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813501; c=relaxed/simple;
	bh=cCjuPrUdA57fETYZFnJHhHG49yp5snyf/u/71+2KJbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmNrc2PQlHro1TnVsQdz/qI0VwNR44Bkp/GO9Mac0bxzDoUo4Eik5tTezGQuNv3YMObH1mYPhJxpIGHKottHRUUTpcupOOJDKJZa67IMLR/I0+6qVdstoOwEEkG0b+W43iELP+JAjz0mj0ZoSuOHRghSbPFvvu0jYrtX5g2y+O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ozk48M9C; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ozk48M9C"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741813488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a39FSsZMvQ9DjuOekvV+Xdsq9nwpLHLFxDXkhuLj9Ww=;
	b=ozk48M9CcNR5HQHm7WaZL2T+eFxtp0MSKh2bFDfJhFHHCxuEPa6oY3iLxUxLK+HaQXaWWV
	J6A9HnYEj3bwsHBkdVjDhXGYf2VLgOW9pP4wvLf/VskbaItKEsty/frECa6dck5ol0ql92
	X/LCS+Vgpm3BVRjI/zaHS2mmW6VZYvE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Writable TGRAN*_2
Date: Wed, 12 Mar 2025 14:04:37 -0700
Message-Id: <174181344705.1158293.6270593433232646712.b4-ty@linux.dev>
In-Reply-To: <20250306184013.30008-1-sebott@redhat.com>
References: <20250306184013.30008-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 06 Mar 2025 19:40:13 +0100, Sebastian Ott wrote:
> Allow userspace to write the safe (NI) value for ID_AA64MMFR0_EL1.TGRAN*_2.
> Disallow to change these fields for NV since kvm provides a sanitized view
> for them based on the PAGE_SIZE.
> Also add these bits to the set_id_regs selftest.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Writable TGRAN*_2
      https://git.kernel.org/kvmarm/kvmarm/c/edfd826b8be7

--
Best,
Oliver
