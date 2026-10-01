Received: from mta0.migadu.com (out-238.mta0.migadu.com [91.218.175.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA2C51C056
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867356; cv=none; b=rXp0A6VGQ3UeOiGiwZT87HymtgyjI6Op7jVj4lRJQbT41pfL86f2YYTaLglwJwi4mufhBYidu8RCrVxYlW8s5Q/fvRdev4xlIaPXF3h3dlAncmHpm/fNMnvmwBq4zd68ua1RcvUtUYTQzwr7/HW+OwRNCljdz82le304oat6cRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867356; c=relaxed/simple;
	bh=lw2QCwyI1de3tv9fBX/vAq97eHvxcHi6AoVHIW9XeDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AazvwLS0kQmUMZzkQKx1fufalJelbmrEma/mWc7ghqlKyd7RXMt9CAG34tjqF2ltOABfq8Gqw8+bVDCj7xZa4TyUvloveU2ZmbOpRPoWBIC5J8WiQd3fl22FVNosMbhKXskX0Ccf6oOdMsqnyJQGXQEydFr8ZUb4iw8WnKhFkXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SY4nMUuw; arc=none smtp.client-ip=91.218.175.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SY4nMUuw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=lw2QCwyI1de3tv9fBX/vAq97eHvxcHi6AoVHIW9XeDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790867352; v=1; x=1791472152;
 b=SY4nMUuwI5tjW0oIp7TDs7v6blhLi6z8xYmNU1kEyc22FKnz6O8hWtyjo64Z16wizlpOKw87
 NOmUdcn4M8QrN6K8XzVI2a9VtsEkPJ+HydnQqRsswa93ZRzNN03Sr/0INDZtBB3s53Zwj/ty7gP
 dTP9dTIkELzXOzEeyIZCz+JY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5449f3ff48277c9e;
	Thu, 01 Oct 2026 15:09:12 +0000
X-Mizu-Trace-ID: 5449f3ff48277c9e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so8640e87.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 08:09:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzWorlRPsb7U8yLYAwPFzaWct7FNORQmYyK61xSzxeRAp+qg98w5nREREG2di7SWPV0h0qUfqE=@lists.linux.dev
X-Gm-Message-State: AFq9FYK9x2mr/S2HABFWHRs4cfw6bwAtpQO9qO0+u0lj5vDHmgojvRhb
	YmAZdUY10GMW6I/4v8YpYAltgUrE2gLb4DC5F+39Ame0XVL6rqVIYnHP+L5gM9vFcjqhbJF/myU
	fmGqAfD7HMtbifXfq0Z7kq5slTj26c9q3aHjZNfWH
X-Received: by 2002:a05:6512:1593:b0:5bb:7b34:8e00 with SMTP id
 2adb3069b0e04-5bb7b3490a1mr44055e87.6.1790867351529; Thu, 01 Oct 2026
 08:09:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-13-fuad.tabba@linux.dev> <20261001142109.794CA1F000FF@smtp.kernel.org>
In-Reply-To: <20261001142109.794CA1F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 1 Oct 2026 16:08:35 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzxW4E3=N81CoS1Va9oN20TLFCKBYpAUpAsXgQAHYAbtQ@mail.gmail.com>
X-Gm-Features: AclHuK_wg9t4iI4DjiapJyfOV1Af6I4C-Kcirapf0cbh6HRjcWOrvVwqZT9ayJg
Message-ID: <CA+EHjTzxW4E3=N81CoS1Va9oN20TLFCKBYpAUpAsXgQAHYAbtQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/18] KVM: arm64: Prevent host PC adjustments for
 protected vCPUs
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Oct 2026 at 15:21, <sashiko-bot@kernel.org> wrote:
[...]
> [Severity: High]
> Does deferring exception injection to the entry path cause host-injected
> exceptions to be silently dropped on non-trap exits?

Yes, by design. EL2 completes a host-pended exception only as the
trapped class's own exception.

/fuad

>
> If a protected guest exits due to an IRQ (ARM_EXCEPTION_IRQ) and userspac=
e
> calls KVM_SET_VCPU_EVENTS with serror_pending=3D1, PENDING_EXCEPTION is s=
et on
> the host vCPU.
>
> On KVM_RUN, flush_hyp_vcpu() evaluates the exit code and bypasses the
> ec_handler for non-trap exits:
>
>         case ARM_EXCEPTION_IRQ:
>         case ARM_EXCEPTION_EL1_SERROR:
>         case ARM_EXCEPTION_IL:
>                 break;
>
> This ignores the PENDING_EXCEPTION flag during entry. When the guest exit=
s
> again, sync_hyp_vcpu() unconditionally clears PC_UPDATE_REQ (which includ=
es
> PENDING_EXCEPTION), permanently losing the injected exception.
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001135711.16=
40520-1-fuad.tabba@linux.dev?part=3D12
