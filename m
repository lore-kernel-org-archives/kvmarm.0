Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88041FCF62
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741082250; cv=none; b=fNYUbmdyqyO6ZDqfVPZPPv91SQfgsIqJ2r4hdkHwmYWrr2RPAwPgRD+0oXPaG3hBmIYRjmG0CJCBSNexGDFNlT2FHB6B566YesC88fqKy9RTaciDxrsxrGlhGYpGwYf53CCzTQNJhtgG9Ur8gb7ObgysDR+Jwv76LkyX18Y2A2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741082250; c=relaxed/simple;
	bh=R5+chWX4fjfkhsjJuY4Smqs/2zQtO3ZQY823JD8d1Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OR8VmRKmVOmx7SHmtTYghvM7zkAiH43kq5VhwpEz729hYiwyZ2OKxYGTK8U/W2N88dclOKdeXVBsX+Lx1IpcZh+w5ibQAgbQOY13HSiyM5fEnCSv/1m8Ml3XNLjuAujcr2c4/qu7z5aPbkl21KnmY28ztcmefi+k7yWarTi0qMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DA69FEC;
	Tue,  4 Mar 2025 01:57:41 -0800 (PST)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBCCB3F5A1;
	Tue,  4 Mar 2025 01:57:24 -0800 (PST)
Date: Tue, 4 Mar 2025 09:57:21 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>, oliver.upton@linux.dev,
	snehalreddy@google.com, suzuki.poulose@arm.com,
	vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: Move the ffa_to_linux definition to
 the ffa header
Message-ID: <Z8bOgetwikZQnUqy@bogus>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227181750.3606372-3-sebastianene@google.com>

On Thu, Feb 27, 2025 at 06:17:47PM +0000, Sebastian Ene wrote:
> Keep the ffa_to_linux error map in the header and move it away
> from the arm ffa driver to make it accessible for other components.
>

If you are reposting the series(which seems to be the case), please

s/KVM: arm64:/firmware: arm_ffa:/

 as it is not strictly KVM specific. With that, you can add

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

-- 
Regards,
Sudeep
