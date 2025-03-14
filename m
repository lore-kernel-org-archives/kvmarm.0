Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004BB15D5C4
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 23:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741993918; cv=none; b=cGL170JH+F3H80NUVyV+iUjktwoGw4WQGHZit6bfk8kBvhODC8UvQ16yXiFIS7Zv6koIVHzjs0V53+3jKeZSLSzSabfum7NNFjbBx4MGC8Yq02iqvZaQ/iwLMluRh385oOtG9k4YB36i5c2R1Ry49X24eOsqbw5pjYLRASBM8dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741993918; c=relaxed/simple;
	bh=vEKrTbtygClroIOehgjcM5oMxYlvBUAL2/ugw/XcSts=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qbHjdtEa70u3vIiE007VbYsCJD3a2UFZ0j28UOJB2tHfJ6W3zjhZ9BLY9wJiFxMDBD8+KiBIin3WVT8UnmNPtvklYCC/2GnWZ4vAul75HwCFv3YuNovdCFcFxeej9EpnGdsYSr4I0e6Y4DsSuZC1NKMkfA1xGjUiwMaAdc37VyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QosJYY8S; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QosJYY8S"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741993913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBRPT1Ef7gcoS5ULW/EAZWPL6EFT3wjf8hjoOpJAfx0=;
	b=QosJYY8SCLXfnl/YptkVZ4xtrXEta31SV0o+im/axw8i46oDXdocV30CtI5WF60Z6PY0sE
	XplUAJNbpebNTlTAoILH6BZVkLN4WT5zLCOHHpNAFWHCbJMT90oghUSau+yYGrYW1HHk7Q
	h15qKNj1pYFwoCg+4ZI+j0vPfS1DkUo=
From: Oliver Upton <oliver.upton@linux.dev>
To: maz@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	qperret@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v4 0/3] Count pKVM stage-2 usage in secondary pagetable stat
Date: Fri, 14 Mar 2025 16:11:41 -0700
Message-Id: <174199388869.1347355.3257172566547296474.b4-ty@linux.dev>
In-Reply-To: <20250313114038.1502357-1-vdonnefort@google.com>
References: <20250313114038.1502357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 13 Mar 2025 11:40:35 +0000, Vincent Donnefort wrote:
> This series allows to count stage-2 related memory when using pKVM. The
> value can be found in the /proc/meminfo field SecPageTables.
> 
> Changes since v3: https://lore.kernel.org/all/20250307113411.469018-1-vdonnefort@google.com/
>   - Remove unnecessary void * cast (Marc)
>   - Rename reclaim_guest_pages() -> reclaim_pgtable_pages() (Marc)
>   - Remove unnecessary PAGE_ALIGN(pgd_sz)
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Add flags to kvm_hyp_memcache
      https://git.kernel.org/kvmarm/kvmarm/c/cf2d228da9a8
[2/3] KVM: arm64: Distinct pKVM teardown memcache for stage-2
      https://git.kernel.org/kvmarm/kvmarm/c/8c0d7d14c5cd
[3/3] KVM: arm64: Count pKVM stage-2 usage in secondary pagetable stats
      https://git.kernel.org/kvmarm/kvmarm/c/79ea66231599

--
Best,
Oliver
