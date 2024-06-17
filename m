Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C392B16D330
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718645035; cv=none; b=eCktGtapk83WfNN4iWsGdS6cCWBe0FfOck5Ma+QMDzGNRwpnDcZPPsv8wkEcOL+Zj37SNHx5yM80Wd9ZS5KnyIIRvitt6tAaHTXOP9kEE3YNqFiMzUCA+YBp2WzkpMVXrQpACF0KoTM/8mWTBSxv8E1rY0wF6gkb72ukxpJ3jOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718645035; c=relaxed/simple;
	bh=SORfSBgW6ZNQE27ov5D4d31BQf1zHhybBDaPHzgrccY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhNyU9S/lTTrr3lJVenfAf4Cmbw2iEkuVm7wc4s9th39VTnqf/Y/7/pGwZ4rGueIB4lTPnz86E+4blU3JKwmW0slsdlVXschhXxFwZm3DIW1S37fWR5wnhRFkhdVnSnbKmdb8lB2q2FyyBu/+4GzUmD66Ixxyrh0c8UcMowmEoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cyS44mDH; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cyS44mDH"
X-Envelope-To: yuzenghui@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718645031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FEFi/yoqejFoClh2rXR7uK+aXn+cjM9Xf9AFA2KklUQ=;
	b=cyS44mDHJBZKZLv64A6EL60ZewAtRCa6uFIIIK0PO0SUQIAZ5yD2c/0bP0RG84NAr3ss0j
	y3A519QGwMx3WbJZbDoxVoLmNCXZqXxYV319nhh1TRfiS6l49pvUQLPyr2PyXxf53I7Bgd
	ExIoditWqIXW8g5aHAqPUP87GYVnj70=
X-Envelope-To: sebastianene@google.com
X-Envelope-To: tabba@google.com
X-Envelope-To: jean-philippe@linaro.org
X-Envelope-To: qwandor@google.com
X-Envelope-To: sudeep.holla@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: qperret@google.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: lpieralisi@kernel.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kernel-team@android.com
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: yuzenghui@huawei.com,
	Sebastian Ene <sebastianene@google.com>,
	tabba@google.com,
	jean-philippe@linaro.org,
	qwandor@google.com,
	sudeep.holla@arm.com,
	james.morse@arm.com,
	qperret@google.com,
	catalin.marinas@arm.com,
	lpieralisi@kernel.org,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	will@kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 0/4] KVM: arm64: pKVM host proxy FF-A fixes
Date: Mon, 17 Jun 2024 17:23:26 +0000
Message-ID: <171864500009.1981502.6509421097479161739.b4-ty@linux.dev>
In-Reply-To: <20240613132035.1070360-1-sebastianene@google.com>
References: <20240613132035.1070360-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 13 Jun 2024 13:20:31 +0000, Sebastian Ene wrote:
> This series contains some small fixes for the host pKVM proxy code. I included
> some of the patches that I already sent on the list as part of this series
> to make it easier to keep track of them.
> 
> I verified the functionality with OPTEE as a TEE-OS.
> 
> Changelog:
> 
> [...]

Applied to kvmarm/next, thanks!

[1/4] KVM: arm64: Trap FFA_VERSION host call in pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/c9c012625e12
[2/4] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
      https://git.kernel.org/kvmarm/kvmarm/c/894376385a2d
[3/4] KVM: arm64: Update the identification range for the FF-A smcs
      https://git.kernel.org/kvmarm/kvmarm/c/0dd60c4632a1
[4/4] KVM: arm64: Use FF-A 1.1 with pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/42fb33dde42b

--
Best,
Oliver
