Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9874266AA
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779892380; cv=none; b=ieBtMtaxgxl6WmmglZuOnOZY3lIEVTLX7KaDis1agxSGoPF6yKgkyyyGULE8BdBqWomMN5r++bpwsAYvtPaukfalwKBH27ATuPKWNVFepN5LCv/wZGwUzUeXy5oueSH6PDeseIhxgZSLRsRjzpzg8DYntqrfXGDRmvRcK0ULeWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779892380; c=relaxed/simple;
	bh=Xys9IY1uNyN2tawUvRlnf53qZlisPQnBFasZr39OO1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EF5tYIIT1r9BU8cSfSIPDZrxsuEhnvjPuinI7OGXwmZEvrqBQ0Jlht9HpJ2xBmeICVzpdc1WGY56sftun9pkfy8N7s4jpw0I2sZsn7m7PPwX0cnGCAwTUY+7hizV2L/V3NRHVhw7M66bQvRxo6326qeIZh2jJmQ9i9D44ScS0e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2EtctAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2EtctAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDDE1F000E9;
	Wed, 27 May 2026 14:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779892378;
	bh=CTIptt7XS14MsYfI5r7PxXNAc/CDaEraJlZvDtwwujE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2EtctAwbFGwBqyKO8MYKINqGVrUo633C9zq/bNzkWZ3GtdNX52VxNvkoYKQnYipd
	 jBonxge68TkMJqZVteDxUQuaZF3F0Izje54wFy7Yj9xsEYsCN11rPFFgHD2lNZf6QB
	 XJNxfKJmshxJIdHbRLWcboQWgXwIdHaSDvB/JjDq5ubcBPXDz0so9Qwe23oNyCTV9O
	 D4kVfgXS0IvM+TWZCFGjgET3HaalRuY8bzorTQ2LOBlsORjtAEb2zZD9Bq43jeVSd/
	 Fs9UXwibr25cw6RjxFocLiRGOMLo8jNcbqMRJQ/I+1AbgZh8sPp174RFWGV1C6skOs
	 uvG3Wyd6Eyfww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSFJY-00000006iFU-1t0D;
	Wed, 27 May 2026 14:32:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Don't populate TPIDR_EL2 in finalise_el2()
Date: Wed, 27 May 2026 15:32:50 +0100
Message-ID: <177989236079.1515680.15500441600167629178.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518153127.6078-1-will@kernel.org>
References: <20260518153127.6078-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, will@kernel.org, linux-arm-kernel@lists.infradead.org, oupton@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 18 May 2026 16:31:26 +0100, Will Deacon wrote:
> Currently, it is not necessary for __finalise_el2() to configure
> TPIDR_EL2:
> 
> * The hyp stub code does not consume the value of TPIDR_EL2.
> 
> * On the boot cpu, TPIDR_EL1 is used for the percpu offset until the
>   ARM64_HAS_VIRT_HOST_EXTN cpucap is detected and boot alternatives
>   are patched. Before boot alternatives are patched,
>   cpu_copy_el2regs() will copy TPIDR_EL1 into TPIDR_EL2. It is not
>   necessary for __finalise_el2() to initialise TPIDR_EL2 before this.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Don't populate TPIDR_EL2 in finalise_el2()
      commit: 4cceeb8da363ac5127b147ee7345104743f53e9d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


