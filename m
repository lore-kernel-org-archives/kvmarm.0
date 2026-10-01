Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86793491597
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 21:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790890443; cv=none; b=FOknltO6VnACR12IDbmCbQzawINbxBt3sEB6/vLAJkRZwxHS8cUjM4w0HNeeiKPCoQhScMGO568TItOCOA6ls3lbVrDRYNBwOmMcb0q1+Ur8vZyoq12DUsIrPinuRatyUoiqx9zR57YYocNwKdRtQkQeTh+eJznxI6JQVcAdCWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790890443; c=relaxed/simple;
	bh=aoQY2n7UuHsEBO2b/7mwS2MVg8AzdCvjCqCqmkccQyQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hgr1RIwH3kTS4FEj1UnhF9dN3QvuHXpYONDRuTXGdD5wJ77VOm+VkXo7ogk7URr6uhAuivH6AUZu5WU9WHwX6YyNIcLhZF5scLhBUqfOoi5QsUcy3RH+ENQE9hwU8vjIkvDEa5NmkOeEZz4l++YsGptwGcX8jtc0yprOmMJew+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=onEb460r; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="onEb460r"
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a7de733fa9so2444425b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 14:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790890438; x=1791495238; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aoQY2n7UuHsEBO2b/7mwS2MVg8AzdCvjCqCqmkccQyQ=;
        b=onEb460rm7lkO8NXs6sBkxAfxVH111jiK0KrlpI+q7njzPOGd1TbdqcRhOaxHl6NzV
         MXFYuFSZSNIEtEMB8ZaVUJTUMnNmKwdJxYlayc8dkS8U0jRzaIr/JtiNQ0572yGMMmer
         S9g8ulNYObgwyYxoWGEny7RK5kS1r3+fIxPGIcWZRjljvLiSfvzr/LdT/6RDXrt9K3W5
         BIhlNOoZICS8+kM/0lXmeYIidpi6lcHSqatnQk0jztxgpWABngYs7pFM9aO+QYJjRcXp
         ByXM05hSg1enzdyf/H6j0y3ZfIy4wqReJYj7TqMx7gamQO9COb6i8fhnlEJOvXaF/Y/8
         ozsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790890438; x=1791495238;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aoQY2n7UuHsEBO2b/7mwS2MVg8AzdCvjCqCqmkccQyQ=;
        b=jUeb/Ij6oA9mOmDgirenFmtiV3+onOQ+8UsdW8JNEph6nRkJ3o4FuO0qTpEeDlhX4L
         Qyn7hTTCBuPnKhHrHeWw+9Pq78msxGL/R5yqO+Le5y2njAM8mj6yo2V5cqYoYwwIjn6+
         o+zN93w/I4Sg4CczK0s0k4e4Ag6PoM6bSXAr/kvnVMnQiQecRisERYHA1VwY+mThBCBv
         zMk0GF7aSQUBNMtCjp4F+92lEh1gTUzqEWxAAoqOM/WpPilCiihog1CwXk0A6Ueb2fwf
         +PhzOFfSwnZBQdeld59mzDdacN6Pj2kZQgXlK2bR/6aMOeH6KXtNfMaVyTJZZJf4kcER
         4S0A==
X-Forwarded-Encrypted: i=1; AKwUvBwkLav/v+BVxaTzTgyXPZb/L7z1pcTYlLD9RViebV9sD3mCkPEZaRUjAilb0jcjqnZMDiBvvDs=@lists.linux.dev
X-Gm-Message-State: AFuF++nlXe/KhanmqX8DcP5yJwLpKwek8amsdRKVttSe2/DVi0tpJNib
	Nzm6Oi2HWeNiv9eaFGRkERB7VA+kNGqyLZTkDF+P2WdBHLEn1pJ3ECRVaJKXiXAsUxB8r+bBas7
	ZxITx+sqcfXIc9u1ovwEYGdKvhQ==
X-Received: from ilbcx6.prod.google.com ([2002:a05:6e02:3c06:b0:50d:b50e:1675])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1211:b0:4b9:a829:f015 with SMTP id 5614622812f47-4f529d297bemr430489b6e.33.1790890437780;
 Thu, 01 Oct 2026 14:33:57 -0700 (PDT)
Date: Thu,  1 Oct 2026 21:33:55 +0000
In-Reply-To: <8e47bb89-a894-4fd0-9f96-e11b5dea1972@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com> <8e47bb89-a894-4fd0-9f96-e11b5dea1972@linaro.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001213357.2088894-1-coltonlewis@google.com>
Subject: Re: [PATCH v9 00/22] ARM64 PMU Partitioning
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

On Wed, Sep 30, 2026 at 04:25:36PM +0100, James Clark wrote:
> Looks good to me, everything seems to be working now:
>
> Tested-by: James Clark <james.clark@linaro.org>

Thank you for testing and for all the reviews!

> There are still a few Sashiko comments though, and one critical one about
> racing with pseudo-NMI PMU interrupts that looked reasonable. I tried to
> test it and reproduce an actual issue but couldn't, so maybe it's bogus.

The "Critical" Sashiko comment on Patch 19/22 (claiming that clearing
hardware PMOVSSET_EL0 loses overflow bits because the guest has direct
untrapped access to PMOVSSET_EL0) is a false positive: Patch 09/22 sets
HDFGRTR_EL2_PMOVS and HDFGWTR_EL2_PMOVS (and without FGT, MDCR_EL2.TPM
is set), so guest accesses to PMOVSSET_EL0 and PMOVSCLR_EL0 always trap
to pmu_reg_read() / pmu_reg_write().

The pseudo-NMI race comments on Patch 11/22 and Patch 19/22 are
theoretically possible in a narrow 2-instruction RMW window because
local_irq_save() does not mask GICv3 pseudo-NMIs, which explains why it
wasn't reproducible in practice. In v10 I will make the PMOVSSET_EL0
shadow updates and vcpu->arch.mdcr_el2 assignment atomic, and address
the other valid Sashiko findings.

Thanks,
Colton
