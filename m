Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBC9193435
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 08:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741939866; cv=none; b=HbkdbukY83QB5UJfvzyVM8whLUf0BCbT0sZ17QhivNgB6XKDlFudhtw+s47HqhJaEUgIH6c8qun7uyhz+M5Q+8mp7U2ia3NAKiVuxsUXYgmFRhPb9ooUAESw9dJsf8bbDcRzLBqfaelzt9QLSQhUSGFQRn4PgtyZROBuzZcx6jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741939866; c=relaxed/simple;
	bh=pO7tTO1rV95NIoQMWhWLdGMcS+ijoaLqtx251avqfLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4Rg03A4Lay7qLQX0jE/cuYmhjk7KQQaTujJBumYW4P2iXGOr7SmGYyOQvanhszUHO5yCJDCalT8wRm6ikX/L2H+67U+Z04uQJh6Tg3gkLJT2C4ujUIObmD7G08FsV83wLtBn6R5+Oshb6HEn8TpLOa4PJTpNuJ54BhasWX8Xv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kFiYHKvF; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kFiYHKvF"
Date: Fri, 14 Mar 2025 01:10:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741939858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pO7tTO1rV95NIoQMWhWLdGMcS+ijoaLqtx251avqfLs=;
	b=kFiYHKvFgG2Jjgo9l3Rdp1qidd2k9Mv7b/wF/TKi73ClvF+zfwzJn3EIbeGIuVKkuoOjHJ
	uZhkeU9N0XONZQDPvyXiJxn1Ce4rR6QlheSzBz/g1OXa9P6wgVN2ciaZ70+MYt2q+o5Zxh
	zvp3pp+6WtTaaAP4I8APYTnMXLq3I5A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, devel@daynix.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 0/7] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Message-ID: <Z9PkchMNGN1cdLgJ@linux.dev>
References: <20250313-pmc-v4-0-2c976827118c@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313-pmc-v4-0-2c976827118c@daynix.com>
X-Migadu-Flow: FLOW_OUT

Hi Akihiko,

On Thu, Mar 13, 2025 at 03:57:41PM +0900, Akihiko Odaki wrote:
> base-commit: da2f480cb24d39d480b1e235eda0dd2d01f8765b

I don't have this commit, what did you base this series on?

FWIW, the patches do not apply to a 6.14-rc* and seem to use something
older.

Thanks,
Oliver
