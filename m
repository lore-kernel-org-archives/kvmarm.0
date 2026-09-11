Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16571369206
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 11:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789126786; cv=none; b=P9rQfRhQVSxc0p+zehKvKVBKoFDoA/7Ca8U+AvGG6vGqxnpNn2llU4dajL370GvOVHf/WpN/u48G+llkUBzCf1CAGujxXsvOmKad6i0OOtIbpD402fJwzU6pxxp0GhrpuwpZ7p+Sg8fq0wYkDzyu6IU5L1MCI4OJTcYjge/lxDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789126786; c=relaxed/simple;
	bh=ydcRpOnkR22BNGIyoUuVd6PI/iDy2Z9Qk4HHkpzzTgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ZJEPFlHhU0eeQRV0Rk378GG8VYu1lIDGQXrRaa3c1RcxHpxqI+pnWJ1f4uraiPGQnBeICEkDMkOpWO1Jg7A/OEzL9m6/KEchMYkU0qwUfn2NyE48ww/KmKw/cYVCGXMx0Ipd2oo2x5tZ6uytYy3GnjjyxAS9ypkHvvDt9TNvpCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GpQcJqCu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GpQcJqCu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF2551655;
	Fri, 11 Sep 2026 04:39:40 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C88D3F59E;
	Fri, 11 Sep 2026 04:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789126784; bh=ydcRpOnkR22BNGIyoUuVd6PI/iDy2Z9Qk4HHkpzzTgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpQcJqCuG/ZF4iG6dXOMof9DXeWosOCDE/6c1tmVl2lpsaUTwWEYo8Jd3C5VuhHdt
	 nycLY+1C3hqH6TAKzFA/h6xOeDwLew7Si0rLFAI7ZBIF048SnMuzI5LAED6TJZFf+X
	 pw/k8DFzLwbIq8It8XpvNDUSzlsGoUERURoIlKY4=
From: Leonardo Bras <leo.bras@arm.com>
To: Normal Person <trontanner@gmail.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev
Subject: Re: dumbass here, asking dumbass questions
Date: Fri, 11 Sep 2026 12:39:41 +0100
Message-ID: <aqPofVT2Oc3SIyBj@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <de8bfbe5-cc0c-4a0e-8d41-e461522385ce@gmail.com>
References: <de8bfbe5-cc0c-4a0e-8d41-e461522385ce@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Normal Person,

On Fri, Sep 04, 2026 at 10:52:49PM -0500, Normal Person wrote:
> hello i am sire dumbass the 3rd jr. this is the arm list right? because
> whenever i search up arm-msm i see something about arthritis and when i
> search up arm kvm i see something about a hypervisor
> 
> 
> is there a mailing list for just like linux kernel arm? or is that just
> talked about in the normal lists?

I think that would be 
https://lore.kernel.org/linux-arm-kernel

Tip: you can go to lore.kernel.org and try the "locate inbox" option to 
figure out mailing lists for given topics.

What I did was searching for ARM:
https://lore.kernel.org/?q=arm

> 
> 
> i am still doing lfs so i apologize if this comes around as pure stupidity
> 

No need to apologise, nobody is expected to know those things.

Thanks!
Leo


