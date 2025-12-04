Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6F12F0C7E
	for <kvmarm@lists.linux.dev>; Thu,  4 Dec 2025 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764868196; cv=none; b=CujXWB54aEAEpy0/gJIR8Att1NxQrX7bgTI4kMI1wa9IoEq3N1fiiQ0rt5TpLymVoiCVPqVGo/5puoAna944dG1cv0aX2KP5rp1S0WI3ZWPziJHt90cc8/ZpqFJVLcAIwPDob8lWQ11v6/GOx3LJPbI+xqeCkyvf5RbAji2y1wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764868196; c=relaxed/simple;
	bh=BWntlgu6tcfCSweNpkczVwC3zE8X9u1J7omu5fjHLCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4pG6WOMawMa57tkCzTAa7PS82E36J5HcnBsu5U+xUe4EEHrupdo9DAU3QKwN7/oTVi0zoybcVj5wzqM66x7EzRusJTzzJt42aUR3G/BAZhatX3Ofo8Rgg6GoQWKZA5Atct9l/lHz9VKAA39uxPXzK3jK1io2aWDYMl3kj18n2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vkWE6mra; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vkWE6mra"
Date: Thu, 4 Dec 2025 11:09:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764868192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T6h+XGJct7IZGL1jcQDWZroeewkEwO15BgcQpYlwazE=;
	b=vkWE6mra/llraEluxinq5dq5hoL7HqhQDEA0ebw4VMMsU7JOvX1lHsO9CEAw1gL5NNB6Cu
	PHJsMiIY8nsg8A7uPUv9jd14tfiQ+ttMR6znDVzmMAnppuBFMpsz+3h4jqdJ3j1umHelyI
	snOXxoVLXPYlh1wU6mfrH076Dt/kuEM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v4 08/11] arm64: selftest: update test for
 running at EL2
Message-ID: <20251204-96632701672b23ff844ba300@orel>
References: <20251204142338.132483-1-joey.gouly@arm.com>
 <20251204142338.132483-9-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204142338.132483-9-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 04, 2025 at 02:23:35PM +0000, Joey Gouly wrote:
...
> +#if defined(__aarch64__)
> +	expected_level = current_level();
> +#endif

Another way to get rid of the #ifdef would be to create a test prep
function for each target in their already present #if areas;

arm's

 static void test_exception_prep(void) { }

arm64's

 static void test_exception_prep(void)
 {
     expected_level = current_level();
 }

and then just unconditionally call

 test_exception_prep()

in main.

Thanks,
drew
