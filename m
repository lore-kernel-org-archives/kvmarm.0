Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEF349BD6E
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 21:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790890444; cv=none; b=eCJDag3opoyjbVjdCZZXhl0PkAd5GcZ+ybyzqeKDPr0dh3Miq/4FXpb60SNTpDYGbnehthtKHEMYxcQ8hR8t1LKJUyiknKGpynUDDxGnvnctqI2pXXO9RF4AUrI2ODHzxh6BZdnqGTy/GNPq0d94yCW1Pc2gS7mwCtg1l09bLoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790890444; c=relaxed/simple;
	bh=aIbawXPVSEHJ0DscG76tmh9vZXpkAHRdIDz4TIVMzco=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LHvqV3Kar2UoYBU+F6qWKKfJFaubK4L8jxdogIqvfBqdUjM/wyXhPF9RsAXH2W0NkGwSddP+ylawEZh17SL+u4vUZr0kpUc+xnjLtWMtZ+E4ld51sPXAr9FOxaEA7EHkNlne15luszywSP4hch9j+iv+CFXRxeF6NbE1593yrEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pThQYtoq; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pThQYtoq"
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b37620eb73so12524428b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 14:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790890440; x=1791495240; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aIbawXPVSEHJ0DscG76tmh9vZXpkAHRdIDz4TIVMzco=;
        b=pThQYtoqRrMqZtChTyWO3tVQb/vP0XD+J9J51gyF0F0NOqUvyk128fhLaHCEYDWfBs
         6MhhlP0pByL6wATUImgvpPF8wMh86wf/tMFA3Wf/haHBVksqczVMwXJB/v0iYhCJAQLG
         qNViHl0pOsRqhErH6HRPBwdzQBFOGXMIr/tiU8qYzKMe9LjWV6yDWflMM5PYfVIk3rta
         8K8go6Vxm0Xinnz7r6s+IJdkDHfjLjx9W6rFatn+u17aCYHW5feG5sVzhT+h9O/HzC9K
         ID1lA+6KH2pnEgGmgVckXgGvw8mH1MaMuRYlPUlvS58zIVi6c/ivwIwzk70iLWWt+HNQ
         Tu+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790890440; x=1791495240;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aIbawXPVSEHJ0DscG76tmh9vZXpkAHRdIDz4TIVMzco=;
        b=vkGR737/okKvnr+drb++IdWmK2AoW35zHtLS/cF7zXvvntO7DZLHybO3gZywlK4+KW
         9IGvc58iXrJL0yYeONRmq4J3Z/U00cHJg5hU+hf8X1G2gnf74gmEtAIHwTmWENqhn/HB
         TKvLEmhwTh3j6Ey2qm4iQmuX2EDnD/g7Hyg0AtF7dbyRL2Qqhewp1+QYLFQswq69Hem5
         7IpifctOu/9lGkR3Bpf3OZjc7vZePGSUwR8CF5rIwgSNDdS0rCuSTsrrH7GMrG1zgHAr
         7t1ZnX4b/T6TgdG8JU/jR9b2PnZIavnyluUX/72jT58DXyHukZB7+W0emqaFOiwtYBNC
         X9Hg==
X-Forwarded-Encrypted: i=1; AKwUvBwyHPXA75ftn++IYw5dEv+wzL58yTa4u99Y4qyXkfoHwnYRWku1mMghuMktz1eYgx4SpQwFHxA=@lists.linux.dev
X-Gm-Message-State: AFuF++mX8PcawfJxHzxk3nhAi1Bli2Y4sZc3OWpPPhZZuS6/jkirz7g2
	7+shJxm/TgWhaNKILHQUSR4TvcsGh/02WiIG5bWTED0cAcWpyGp8SPuJjO+mA9SVOzRxGvF/Ora
	XfhqqKYpR60HdgnuoHJMz/7rsUQ==
X-Received: from ilbby7.prod.google.com ([2002:a05:6e02:2607:b0:50f:46b5:b429])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2219:b0:4e6:6079:c33d with SMTP id 5614622812f47-4f5292ffc0amr467127b6e.10.1790890439463;
 Thu, 01 Oct 2026 14:33:59 -0700 (PDT)
Date: Thu,  1 Oct 2026 21:33:57 +0000
In-Reply-To: <f54b9ea6-48b1-4f6c-92cc-b0a9249c2fb0@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-17-coltonlewis@google.com> <f54b9ea6-48b1-4f6c-92cc-b0a9249c2fb0@linaro.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001213357.2088894-3-coltonlewis@google.com>
Subject: Re: [PATCH v9 16/22] KVM: arm64: Apply dynamic guest counter reservations
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: Colton Lewis <coltonlewis@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Zide Chen <zide.chen@intel.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi James,

On Wed, Sep 30, 2026 at 04:28:37PM +0100, James Clark wrote:
> If you enable pseudo-NMIs, watchdog_hardlockup_enable() installs the
> watchdog using a pinned PMU event. If host userspace also has a pinned event
> on the mandatory 1 PMU counter assigned to the host, then a guest could
> potentially squeeze out the watchdog.
>
> I'm wondering if we need to prioritise kernel owned events? Or we just treat
> them the same as any other event, and with PMU partitioning assume they
> can't be guaranteed to be running? I feel like you would expect a watchdog
> to be a bit more than best effort though, especially if there was always a
> guaranteed counter available to put it on.
>
> I didn't follow it through completely, but it also looks like if the event
> gets squeezed it would enter an error state and then never be re-enabled,
> even after the guest stops running.
>
> Note, that I think the current ordering means that the watchdog won't
> actually get squeezed out because it's created first. But I don't think we
> can rely on the ordering as a strong guarantee, and it might get broken by
> refactoring in the future.

Good catch. Even without future refactoring, creation order can be
defeated today if /proc/sys/kernel/nmi_watchdog is toggled off and back
on at runtime while a userspace per-CPU pinned event is already open,
giving the re-created watchdog a higher group_index and causing
merge_sched_in() to put it into PERF_EVENT_STATE_ERROR when a
partitioned guest takes PMCCNTR_EL0.

Prioritizing kernel-owned events (!event->owner) ahead of userspace
events in perf_event_groups_cmp() and perf_less_group_idx() guarantees
that a kernel-pinned watchdog always wins the mandatory host counter
over userspace pinned events regardless of creation order. I will look
into adding that for v10.

Thanks,
Colton
