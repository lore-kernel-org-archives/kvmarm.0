Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09D52E62F
	for <kvmarm@lists.linux.dev>; Fri, 12 Apr 2024 20:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712954687; cv=none; b=XKBIWEAQw3K1NNPEkZcLFixgO+8TEJssnwRbx+QjY+9fanwbRKgf5/Q+AyVOPtL1/TKvVDzPRUYZyKMOvnaJYXoJv/Nt/2Jbk4/GJJn5BbuhaPGSe2Ki4N+PKbKgcHr1b1I1KnjyTEC8vHOazu+YUV9XQdxr2EXw0bbwkyCqtt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712954687; c=relaxed/simple;
	bh=4vp5qyEZGAMwuOagLnJKbRJSa5AiEMRLbDSwvkWArmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2kVj+qJjkeYEFO8A6a3hVERmor1Vq3AOJFBMNFKqfSvzmRMp5JLApcebHR+4N2qu2JHIv4BjTr4B7yiF/KdvxcsOe/hXJubWFkzpZizcex+jaVEqDdw0p3ifSOyX/GCbzkQRPaMNBNeG+Yv0aW2IQV3EwsWbQGbUxeJbRY9z8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z1DPvTY/; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z1DPvTY/"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ece8991654so1255576b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Apr 2024 13:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712954686; x=1713559486; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7z+VKNpPRufGEfzC58h5hLq5eFFz0DWRzzztXBo7m7o=;
        b=z1DPvTY/l2VDkBLqoA8mTDNUX7n1BQ38fj4F01Hox81+4uUnv9dNVu5UyD52t98rNy
         +ResQcAu441cxP7NYOqw6hrA3repi90ZAPg1PqPANeENMaliAulo1aKt7csX5+I7pWz8
         pDS4NRf/Jvgh8i3kvaWLayS5UC54cpOqOEZMoslHCn8XEq3ztanqnJnJDc6FhXvO6NWr
         vAf+eZzuFxSLZSNyDswT6Ly+Y4tfLk9E2tp2/Fy0zqTxA8nz8fxR3YzuZS7G9Itp7T2N
         YiXjm5mExJt20eYNUfCSVswkdrPN7s5evZ4cE47AnL3pxDitj3/Qw5/PpFuYlFmnipRk
         a7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712954686; x=1713559486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7z+VKNpPRufGEfzC58h5hLq5eFFz0DWRzzztXBo7m7o=;
        b=vXRn6yBYHEh+l92K1GNBn0G1tc8SWc5saVPY8C6V20cX0HBL/xvRbQwETh+jKisqYK
         0J2xCkS3dgy24+DJyBnTWe03cqhP2AOiDeTcNzS+Lm1vfTBCP7Vk9XZ5t1dlKki9Dv5R
         oaCeLVfTYe/grLm0zd4jVY0QlJytUUXZP/ILk9Uowj2z99WZjdKibKFlP4PRsGaYm171
         nOZO3I3WdsuVjT6+LgUcdYKZ5LKl00/O3gsW+aXbwcWkKHgYkC92Rs+ynX+ZomU9AKtC
         dYFZThTAJd9EbiJf6v8ATQZq/p+pF20YcHwDVfrmHVO2/joBYpZDJ2WvRB244uV3yQG5
         xivw==
X-Forwarded-Encrypted: i=1; AJvYcCUKyptk3zvoAm+PfvCZCyF+uaDTv7uWXk/Xgyp9HJe28KTNp7Vv5GwQBYohRlhn07crOwZAynDxwloS1F9Xup6scr2gc0Dy
X-Gm-Message-State: AOJu0YyhE6kgo2lSKOkP02UwjhA4gIgucSx3LEoqjhL2L5Nuou0nu2TI
	UyJyIc1aBRAb9+e4g6t3x7Scz8OknHwKHc0IUs4YckLLCgTHKfWjE9HZFDYSvg==
X-Google-Smtp-Source: AGHT+IFZFKdCRdPaL3Vb0XTMjnUQNtJVoruOo48GxoyfTAhTrJOnmmO+jVgRuAaY5z2jRsVdxr03aw==
X-Received: by 2002:a05:6a20:8428:b0:1a9:6c42:77f5 with SMTP id c40-20020a056a20842800b001a96c4277f5mr4669546pzd.59.1712954685790;
        Fri, 12 Apr 2024 13:44:45 -0700 (PDT)
Received: from google.com (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with ESMTPSA id lr31-20020a056a00739f00b006ecfe1c9630sm3368108pfb.92.2024.04.12.13.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 13:44:45 -0700 (PDT)
Date: Fri, 12 Apr 2024 13:44:41 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
Message-ID: <ZhmdOb7lAd3DM5Tq@google.com>
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401232946.1837665-6-jthoughton@google.com>

On 2024-04-01 11:29 PM, James Houghton wrote:
> Only handle the TDP MMU case for now. In other cases, if a bitmap was
> not provided, fallback to the slowpath that takes mmu_lock, or, if a
> bitmap was provided, inform the caller that the bitmap is unreliable.

I think this patch will trigger a lockdep assert in

  kvm_tdp_mmu_age_gfn_range
    kvm_tdp_mmu_handle_gfn
      for_each_tdp_mmu_root
        __for_each_tdp_mmu_root
          kvm_lockdep_assert_mmu_lock_held

... because it walks tdp_mmu_roots without holding mmu_lock.

Yu's patch[1] added a lockless walk to the TDP MMU. We'd need something
similar here and also update the comment above tdp_mmu_roots describing
how tdp_mmu_roots can be read locklessly.

[1] https://lore.kernel.org/kvmarm/ZItX64Bbx5vdjo9M@google.com/
