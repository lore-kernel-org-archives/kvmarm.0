Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8B2325727;
	Fri,  8 May 2026 18:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778263407; cv=none; b=NhROp8NtrFIs2qq3ugx5BYEQSzZncyfChv1KcoT2kXF9gFtkzLlMRrwWsXJdRTe+MmSTkHplJNNiRxetkvELCIi6kcgx+79+i/vgTJE8isOt7aUlz4XMZTBxUb4WFgWhAw+TAMXXQOLSHzE39yOgt1ayycAu2MHh3O7UItlCFAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778263407; c=relaxed/simple;
	bh=gRptDwEx5Olggysp2cl05eC94pvp5bXMa6WQd1kwThw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8H06ML1jdqWZKLhP+zsffYWNeGA6mIrwwAAcFdguoP1e6Ez/dtfjSSXWSGUqdpMnMmErslFHQn3xN2W5HlZNCfMI/DuxDmo0t/P6ZWpcKIDYkt9PzRy1cfp27FIOgLvUGD6Fl5Ja51n2bu5nh0C0t6mSEd1PKPWnFBBxgRJZpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGtIvjj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGtIvjj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C58C2BCB0;
	Fri,  8 May 2026 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778263406;
	bh=gRptDwEx5Olggysp2cl05eC94pvp5bXMa6WQd1kwThw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fGtIvjj6zgHryWrC2ks3Lhkbk4+4wiCSpEnJK2UiEuxERypT5ko9HdKjUQUgCW4vi
	 DBylH6WdUDGcD+oQygQG/RPKwg1O5exe35O0NeU7t+pT1p0CuqUvYTfwX7XfR9SMJk
	 3UsXtM/c8SNA7heOzR7s5oJkJOSQHroLN3DM4Zoa00zaxsMceEz/5ie0S3EghR7LDf
	 LZS5MCLEKf06jgvRxbBNc1455jDbWbucYAZ/KE5IAPAK+OknRZ7+ItgXg2JvIRFLeH
	 f2aGSUAABO8cE+coElw5mGoKN5gKbOVhQOPBXT+S+LQckVDlkiLWddTfKKnW6cQBa2
	 O/cT9ISfBIqzQ==
Date: Fri, 8 May 2026 19:03:20 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	jarkko@kernel.org, jgg@ziepe.ca, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com, Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [RFC PATCH v3 4/4] Revert "firmware: arm_ffa: Change initcall
 level of ffa_init() to rootfs_initcall"
Message-ID: <20260508-elite-macaw-of-success-efba21@sudeepholla>
References: <cover.1777036497.git.noodles@meta.com>
 <2e7b4dc552b45ddf14cc43bc449cbebb4ade0027.1777036497.git.noodles@meta.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e7b4dc552b45ddf14cc43bc449cbebb4ade0027.1777036497.git.noodles@meta.com>

On Fri, Apr 24, 2026 at 02:24:42PM +0100, Jonathan McDowell wrote:
> From: Yeoreum Yun <yeoreum.yun@arm.com>
> 
> This reverts commit 0e0546eabcd6c19765a8dbf5b5db3723e7b0ea75, which was
> added to address ordering issues with the IMA LSM initialisation where
> the TPM would not be fully ready by the time IMA wanted it. This has
> been resolved within IMA by retrying setup during late_initcall_sync if
> the TPM is not available at first.
> 

I have made this part of [1] and intend to take it via arm-soc. I don't
see a strict dependency on 3/4 here and one can test the -next integration
branch. I don't believe IMA/TPM is in arm64 defconfig, so anyone testing
must be aware of all the details.

Please shout if you disagree. TPM revert can go independently IMO.

-- 
Regards,
Sudeep

[1] https://lore.kernel.org/all/20260508-b4-ffa_plat_dev-v1-0-c5a30f8cf7b8@kernel.org/
