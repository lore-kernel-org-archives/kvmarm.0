Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BE13BED73
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 16:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773678861; cv=none; b=UAZHRuerJVLdS3sFoZmO16+EvguYE16eS8QL5J5sUurOtsE+giovs3Q8BbUFCF+K7oMflSRFjiS1jZhKKtK5ZuV70anNHWbF4ThYALNPhiruV+DUXMr6fqdgi23TViJShuJKdGGz2WvOkXEmrY+NQHPiXPWl6KGQGHR1LdvlfLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773678861; c=relaxed/simple;
	bh=4e3xr1Yvnx1M2Zx0PPtR9s5qcN1uXHC3ZjkcgVtJcEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=East1P5hJBbodtdmoIZ4invHzYuULmqdOFR3cb82RwcDW4Dtk3snuF2ss61Wa/GM/Ayus5v2t6smJHJprStZu9n1s+CQED/8jxgSvuiUkaIVcMN8uaKXuI9GFFuPpcKkfmmwn6FwPp2OIXxEhrG0tQG7DqD7k4mKO9+eqLG5Y04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DD951477;
	Mon, 16 Mar 2026 09:34:12 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E7AD23F73B;
	Mon, 16 Mar 2026 09:34:15 -0700 (PDT)
Date: Mon, 16 Mar 2026 16:34:13 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601
 2025-06
Message-ID: <abgxBRUgKBhFBbzc@arm.com>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-1-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-1-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:00:53PM +0000, Mark Brown wrote:
> Update the definition of SMIDR_EL1 in the sysreg definition to reflect the
> information in DD0601 2025-06. This includes somewhat more generic ways of
> describing the sharing of SMCUs, more information on supported priorities
> and provides additional resolution for describing affinity groups.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
