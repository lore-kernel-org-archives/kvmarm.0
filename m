Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EA34A3D20
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860336; cv=none; b=cmcuxbdg7bNe+NY1wRLrbXlVplL6lZJtUZIA/bHo3pNpAs8hrvDPDHkUfBe2zvum+vSl8GObPPgQGna4q7lWlmqaYUp7+4kBEDRrIXj+JHIEM8OOmOPPBgEliAlXXp5o/8iVXWiWJb8Khk/3HvhuRFyrngoVHkzCoY4XMunCi9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860336; c=relaxed/simple;
	bh=B1MeEhDRbJ1+eBXmdpTqqYccTAe1bu1lIrhcKUuTIqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ke/sRLh6ryfGOxsdWRJadaRywHO8IEGg6U5vpno1yDQuM8+A5vPSsQWP35WpYJU9c/PC4/TWRO6HO1JAGKFEjeEmwD0AiudFqFS+sI3MCsMZA8axxlI4xMqJpyOa9k1FU2S3UC0/7o3Wsy2W+7B4P79kT++odtuuDz55XtPaZcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UZE4ZLvQ; arc=none smtp.client-ip=95.215.58.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UZE4ZLvQ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=B1MeEhDRbJ1+eBXmdpTqqYccTAe1bu1lIrhcKUuTIqA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790860330; v=1; x=1791465130;
 b=UZE4ZLvQz1+kRB7m72Y6rgUAz8o2NFrzh/ikH88YscgR97/qIWRhfPoLVssh58UEHYq0yEdp
 lvBa47bFRpkkDBR1mTXMv6zRAwsLVNTDVcPxAdTMwO6AyHRZF0TftIdzih2qJMYT2Y9ueQXzr3W
 p8EsUY5tkyifcBs79+INAkfc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 548390ef35c0ee33;
	Thu, 01 Oct 2026 13:12:10 +0000
X-Mizu-Trace-ID: 548390ef35c0ee33
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba4065fa07so7593e87.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 06:12:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz/ImWp4s3RDBPAbuZrN6CY7DqwliD835jtQNYcb0Nn90rU4SpFK5kF7MvSjPl50bro2qw8MRM=@lists.linux.dev
X-Gm-Message-State: AFq9FYIpVzddppRnQ/mhDAOpxpfSBPRML3Dmx7IkyvusZmd3jd8RjlWD
	yOMZGaeOIN6TtHGFjVZSGshZqp2d5ypHRfnVbrHBecs2Sb9RuhKuIG/RusYcu8XBuLlb2QXtqFV
	S/NKmdVfT7P49luJo0WN58LaZYvLBkhH1xVxRWLM/
X-Received: by 2002:a05:6512:b8b:b0:5b4:74e2:4171 with SMTP id
 2adb3069b0e04-5ba43819ed1mr170584e87.4.1790860325842; Thu, 01 Oct 2026
 06:12:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-11-fuad.tabba@linux.dev>
 <ar5ZLxL6-mz98tpN@willie-the-truck>
In-Reply-To: <ar5ZLxL6-mz98tpN@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 1 Oct 2026 14:11:29 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzJTpJikYuV-tYYoHbKU+E3UO3ORSdbogx0K+s+E6mofQ@mail.gmail.com>
X-Gm-Features: AclHuK-BYP5-ESF0Lkngn2s3wyk7cTX09ixjLrcRsslFsyjwg-j-q23Rg_ftXRs
Message-ID: <CA+EHjTzJTpJikYuV-tYYoHbKU+E3UO3ORSdbogx0K+s+E6mofQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/18] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
To: Will Deacon <will@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	steven.price@arm.com, vdonnefort@google.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 01 Oct 2026 13:59:27 +0100, Will Deacon <will@kernel.org> wrote:
[...]
> > +    if (prev != PSCI_0_2_AFFINITY_LEVEL_ON_PENDING) {
> > +        /* The only other writer of ON_PENDING is the rollback. */
> > +        WARN_ON(prev != PSCI_0_2_AFFINITY_LEVEL_OFF);
>
> If you go with the idea we're discussing later in the thread, then I think
> you need to drop this WARN_ON() and the comment that goes with it.

Will do, both go in v4.


/fuad
