Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0D5182B3
	for <kvmarm@lists.linux.dev>; Wed,  8 May 2024 06:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715149547; cv=none; b=LQlhUVuD0QClBbKrH8XjBfmm+AYYOV8xjLAUQb/cLKxioa5HmNjR2QvlXObMKwrq+Y+NSKXxroNsoyjpzFB9bgLcdV36ICn1/c8ROsqYeNfH9XBAmuDtjINs6IC7L7lvktrLXWzSF803RBbVUZ8BxWLQ56hVfOAo7AuPdjEk3LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715149547; c=relaxed/simple;
	bh=0yTnDzRzl6YMEDAYdK4MzUFIs1RryobdwGldopgZgrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zp9BSvDDidUUk7aaTCpdSus+LxJR4GC8JzFd7oecxZ8dEJDHnS0lWXylUG+1s2ibx75EukXPVEJudfjQve3KoM9gOF4Oa5wQ/Znvl6/cupynm8HONuK0mnjKdPu0mnldp1ed9fY7tBT315d6LN5cwuFQOjw9kto/En012TO9weo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vh1PdP00; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vh1PdP00"
Date: Wed, 8 May 2024 06:25:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715149544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cX9UDFEcMUiOwQWR3+txM6O/c7psSYzDc8seRaVOFUA=;
	b=Vh1PdP00Hz0dsjoJ8XSe+qAtpu16Gl/4TaRhsPZ3AnqRi04QNU82oEK7OXqFZH7NOcVwXg
	7Ua/e5i8KWFXYzf9bVHTz+fHUkVvEm217ZgRHX9ISZtqa/oPPeSwyVV/0Sc2h1xdGJSLkt
	wLnhCNlaP/Y6fwqO9DMHaKu4KWAfCwQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
	shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.8 18/52] KVM: selftests: Add test for uaccesses
 to non-existent vgic-v2 CPUIF
Message-ID: <Zjsa4yeD_EmV7TgP@linux.dev>
References: <20240507230800.392128-1-sashal@kernel.org>
 <20240507230800.392128-18-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507230800.392128-18-sashal@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi,

On Tue, May 07, 2024 at 07:06:44PM -0400, Sasha Levin wrote:
> From: Oliver Upton <oliver.upton@linux.dev>
> 
> [ Upstream commit 160933e330f4c5a13931d725a4d952a4b9aefa71 ]

Can you please drop this and pick up the bugfix instead?

6ddb4f372fc6 ("KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()")

-- 
Thanks,
Oliver
