Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9033134AB
	for <kvmarm@lists.linux.dev>; Sat,  8 Nov 2025 11:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762603149; cv=none; b=ApQOJTWVJfZ+g2UxpvssXuex807CJsIdPibtQ6yTi+6UfK0Czvzo3SIot4aOvCifFhEk0Wcor/bE9mn9Qqb8dmh7mXkm8gwDog3OKinlcpRZmb0LwjvBsxdVfNY6fSk9tIlQ4BxdCegGUlIrLh1QgM3BIOKDa2efyuDpnnEfn0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762603149; c=relaxed/simple;
	bh=Y3iSqb3HTbKt1dNb0W+nwqDdFI+U1aMNlN66yA4/e9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eX5C2pyv7E+DbDE2QlJEOhtJzyW5RWQJj02q/f0Oz1DHX5Aqc3QdHjYbqEV4kffIDnwQnDTmj43e1DR40sR+mpvtW32DYGXzToNWVYUnnUIyqxxlfv5Mu023bIycsydHJOIoeKN1a4ZF5MQM9yVIFHqxZiDbfsj3rd7/IG6xNuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m134L+QT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m134L+QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31791C19421;
	Sat,  8 Nov 2025 11:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762603149;
	bh=Y3iSqb3HTbKt1dNb0W+nwqDdFI+U1aMNlN66yA4/e9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m134L+QTJ6VvCTfmp60dXCJilZiAxvubs+x536L5u/OhhZN8rK3gxDiqdsJD0+k6S
	 lTJpwopqGIHoGpX6oHMkGGwGoqEyD8lmuPYvsT7F8uv3rEcjOihq0X2gvmLS0nmYLu
	 rlQdeqagkFXc15QSbxkUtdAVyT64ZH7wGxhPyc0cznk+B5G6QrjtEtz+JNDrqgsuOP
	 LY7KixtqHBdX1hgV/v99vYIOCdP5dYyIzhnme+dGwKYE4lTln8plRLhuxr6HR5TytH
	 dHGKihGhxSTyDnNJMR2tslz4c7nR6GyL6IV11X1+d2WP3mHLD0STfoLddwGFdusQJo
	 3+VDVJlwoHa/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vHhb1-00000003TfR-0VsG;
	Sat, 08 Nov 2025 11:59:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] MAINTAINERS: Switch myself to using kernel.org address
Date: Sat,  8 Nov 2025 11:59:04 +0000
Message-ID: <176260314405.1201203.11466193554966838680.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251107012830.1708225-1-oupton@kernel.org>
References: <20251107012830.1708225-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 06 Nov 2025 17:28:25 -0800, Oliver Upton wrote:
> I've been running into issues with the linux.dev email
> semi-periodically, switching to my kernel.org address while I go figure
> out a better home for my inbox.
> 
> 

Applied to fixes, thanks!

[1/1] MAINTAINERS: Switch myself to using kernel.org address
      commit: 4af235bf645516481a82227d82d1352b9788903a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


