Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D9C4C91
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 00:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746576420; cv=none; b=a4TJPQEdDZQEdzsGp4fYMnveEZuM+fwZMHooldL5Aazv4KLKDd05i9CDKX6lJ9PsrXoBsIC0LEokBsJRmKpg4ki7WOgd2VesRXZB4cxsZFBseGm/UTzXVo4adNb5OBuGSyO6aGGeixll3FbHXHRbDnyJsMkLbziykEa1ivJ1mz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746576420; c=relaxed/simple;
	bh=B/Q1rqo7fV2BZ1TxyIdMZoX0YUYdDfRp12zBu+jtqb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i6LnYWfXWE0NN4rdJqFyn8RgsRk33xLfWyFEdXKHSg0amcrc7rP7eiuK8SfHg+/bMsnq+NlB3k7gFd13W3BIRlQu2bC90kLot2pVk8E1xJ1wvFvWGln8eehDjYUWUVMgywhBYrJXaKYdPpHe6MQsA4P66QbHKOwdi9Y8KQVhlIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vktrIFEV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vktrIFEV"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a59538b17so3541428a91.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 17:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746576418; x=1747181218; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=btn3LhqGUmuW2q5LXm3m4DGAhqR2o0uzT2Xd87u051w=;
        b=vktrIFEVMj880xHkUbqgnImoBvBauOMxG5h6MLm4TQxDVj2fO04qpGN44hjIKZb7MM
         jvOXIi03dKAKCQctGhk9wiXvAOEpQuoVNsJV384G5uf6na8Jigu+p83dhLg8e9SBJ42w
         AVEqk6+E0TiaiGNxSDhEU8lLSj0E+RKH8PRyoRc7EZa0gbw4MT1YD5EEZx4sVLX0//ye
         86TVcrqdz6rmaEKNLBl1X40/X8dmcQ7j5Cq/ejlWTbuWiwH9P9vz36eifT2R0N0JITv9
         /yoKe6Hc8B5J31B4A6hDA/Uk8J4r6yHIL1ow0LWjB2GOsV5bVjZIUibCuT/eOxNEdw2X
         xxzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746576418; x=1747181218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btn3LhqGUmuW2q5LXm3m4DGAhqR2o0uzT2Xd87u051w=;
        b=jUGvZvllvLP0YKIorODImct4CuEfe5C3Ai3aZCrllo/6Mc5XfVJPCFLt6TR1a0PTkW
         2MylybOF9Xod0uYUySmHhw7RZkK2n+fN9HFMNMCrHxqeXye+7m2tQ7R/ncKR5wm9/Et0
         L6lhdddTfceg4q3H/NGUOdksLtFpD1+R76RojW7W5shXawdy8a+kpjsS+qTylw9GOw1r
         ZesywhEEt81oPie0eZ2MsyGJTLbGEvrrZ3G4cZjaLlchFaVlmJrzqIkagsrf85nm/uQT
         SYbqJf/mAqgYYS5nrjW3A65G+vfHgW+P1LLjujRhUG5656xMBvez8HP07SqHxzxrk7pr
         jZag==
X-Forwarded-Encrypted: i=1; AJvYcCV00pODMWgur6LUdAkCYtvklwleWsyztCviEk/XyZOsdXIVAafZb632MBglcAdimjvT/LcdYxo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8vkQ5RMv/OdnsTC+DWH4L5lcijoS/E1Zi0pv+LncGewujnUcM
	91OfRDHxPg327PMoWZQ4A6GTVRxWL/AclDS/JFsOEV7IvLbFqzdLCayTrFnK0Ze/QBfyxxCaE80
	7Cw==
X-Google-Smtp-Source: AGHT+IE5kiyt3mLLPMmlAjvZ9sp27wxLvnJ1rcyvQV12u4OmcEbBS1ad1jPVl9wL0g7JEjpFk80jEUXWV/s=
X-Received: from pjyf14.prod.google.com ([2002:a17:90a:ec8e:b0:301:4260:4d23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc5:b0:2fe:99cf:f579
 with SMTP id 98e67ed59e1d1-30aac15ed4amr2041810a91.4.1746576417804; Tue, 06
 May 2025 17:06:57 -0700 (PDT)
Date: Tue, 6 May 2025 17:06:56 -0700
In-Reply-To: <20250109204929.1106563-7-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com> <20250109204929.1106563-7-jthoughton@google.com>
Message-ID: <aBqkINKO9PUAzZeS@google.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, James Houghton wrote:
> @@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  				   enum kvm_mr_change change)
>  {
>  	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +	u32 new_flags = new ? new->flags : 0;
> +	u32 changed_flags = (new_flags) ^ (old ? old->flags : 0);

This is a bit hard to read, and there's only one use of log_dirty_pages.  With
zapping handled in common KVM, just do:

@@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
                                   const struct kvm_memory_slot *new,
                                   enum kvm_mr_change change)
 {
-       bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+       u32 old_flags = old ? old->flags : 0;
+       u32 new_flags = new ? new->flags : 0;
+
+       /* Nothing to do if not toggling dirty logging. */
+       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+               return;
 
        /*
         * At this point memslot has been committed and there is an
         * allocated dirty_bitmap[], dirty pages will be tracked while the
         * memory slot is write protected.
         */
-       if (log_dirty_pages) {
+       if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
 
                if (change == KVM_MR_DELETE)
                        return;
