Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826C1522EED
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867460; cv=none; b=RBcucBa/qn1IS4c5aX29JU3OVPXukn9wRK9oBx525gaWSB5AMWpo52y+KKfI7d1jLy95kNEbdLkD4sOBpEMwsraiUoK13+4PItUX/EVNnEPSY0/g9lRMsmM/CA8ZlN5PHrXeMSmFRZxZ7k+DCiB6nFvSEHV6pL0zzbFnNq4xVQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867460; c=relaxed/simple;
	bh=zyQ1FROdiUq3DNEwgy8qntsXEFA0atog2LJ+5V12znY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G383C71BG/i/mjm4hnrU7xMP0WLxwV85nnA5gS3Cf8kZeDLFj6CsTwWfk3xdYHaIELNWtSK4/CCM1RmjavwL4EDV0XvtrQpvAQ1E/sjB3b5DuOkr5r6Y8DdjeDgZYFnwcUutTicQqY3cvQRB8Yu2iZ+GV4jiwExDfwrvA5CkT1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=daAJ96cf; arc=none smtp.client-ip=91.218.175.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="daAJ96cf"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zyQ1FROdiUq3DNEwgy8qntsXEFA0atog2LJ+5V12znY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790867456; v=1; x=1791472256;
 b=daAJ96cfI2zQC4PLz78Qb+jkGg1khg0r3s2cAYpQVXYZOfQmWc4GeMCSEMJZtBNLCjgVjcDY
 4LIxr68WXWgrJj3ALzsOeCjqMqza3onzjONstnt6mZ13sKrVn1D5j5nd/C0G/dRC7xFYL9L08Xa
 RwCz6AbvldekBcqus2MSoEFE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c3f3a13f3479d340;
	Thu, 01 Oct 2026 15:10:56 +0000
X-Mizu-Trace-ID: c3f3a13f3479d340
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5ba3d1ea20cso9863e87.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 08:10:50 -0700 (PDT)
X-Gm-Message-State: AFq9FYL+ZQDUV2qOHnQXBQoNspDNm26TBT9ZGyqNWm/fENB3pPYhabBp
	9PNo8KPzk4eazrVzYQoVcBypU9Ko7np5y9zvsMLONYn52l5tUM0O/7kpGqhxIXKekjcAngvhntR
	C2Th+NQiAS6ktaxfh41ZnACEoN+NjgYf4sShO7PlA
X-Received: by 2002:a05:6512:3194:b0:5b8:d04b:a1be with SMTP id
 2adb3069b0e04-5bb7944842dmr65925e87.2.1790867449950; Thu, 01 Oct 2026
 08:10:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-17-fuad.tabba@linux.dev> <20261001141827.B97661F00899@smtp.kernel.org>
In-Reply-To: <20261001141827.B97661F00899@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 1 Oct 2026 16:10:13 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxphbwjXvuCiF3gFy+p7OVT=TdQTO0vKkZbOZkvRT9Eng@mail.gmail.com>
X-Gm-Features: AclHuK_5sMBjcN4lmvUtlFiUWRdtGWfAXLAoeNruxxE9uee1mazlgZ0PLIW_hXA
Message-ID: <CA+EHjTxphbwjXvuCiF3gFy+p7OVT=TdQTO0vKkZbOZkvRT9Eng@mail.gmail.com>
Subject: Re: [PATCH v4 16/18] KVM: arm64: Reject host power-on of a vCPU that
 EL2 holds powered off
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 01 Oct 2026 15:18:27 +0100, sashiko-bot@kernel.org wrote:
[...]
> Does this break the userspace API for KVM_SET_MP_STATE?

No. KVM_SET_MP_STATE has never accepted KVM_MP_STATE_UNINITIALIZED on
arm64, and the host can't restore a power state that EL2 owns.

[...]
> Following up on the KVM_ARM_VCPU_POWER_OFF initialization above, does this
> condition incorrectly reject guest CPU_ON requests?

No. Before the target's first KVM_RUN it has no hyp vCPU, so
pvm_psci_vcpu_on() returns INVALID_PARAMETERS at EL2 and the host
never sees the CPU_ON.

/fuad
