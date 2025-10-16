Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217A9225A3B
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635815; cv=none; b=NamZlInDlSzIZr8YoIvL79cSdX5gvDhrgYTl16utu2T0m4e9zK7WT2YTnact2k2ZeoQQAYaitRzfkXtESf35QldlnnzDFhTEpsok7+ZInfjxLawxaKQT9Ljtqm5kWl1NjVWbR7YNXb8F2HzjiZPk69Rew5vBoayCo3Cpu4bH9Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635815; c=relaxed/simple;
	bh=Ru4m8I7GXDakLu5/QZ8fZL1qLohr4A91qPbj1pId4+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j8wff1FC7StdAW7cFblAD0wyxHE0iuot3Txd8llki/ArUMEFVR5v0zdk84XeUS7JGS6JmaagBjif3rNRWiGewMCQK0VbyZyELdvKsDzB6lbcHwk9kNf1Eom695wcY9ifYsxnKAlBv7cOOJwoWhNzQRlHIjxW2kJy4II1zS7bMJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jkixsIXR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jkixsIXR"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so890680a91.3
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 10:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635812; x=1761240612; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6tAVv6b9fRDhntp0ml3AD/e15cFGLUttzwV4nvdq0R8=;
        b=jkixsIXROoQdSGKXqdrPGngB0kV66j5ce3DdckjsbMY6RLsWlnK8GJ3gi/y9XsFEnn
         Wn75DpRqftkfst0s88RgkvRx3vMA51l9PejfqwhPmLxwzJc3MIfQYQ+5JL5+WWUjI+ud
         NEQFlBnakC29hzwlzEtB5zVZAl9XrP3W5Rk38r6u9D4Pq0Fhku87D0Xb8SmYPwtbpKEL
         a/xH5FbjcFUYtv66v7vWFPbKk9uOwnlQ77ccitiIXq5Y9AqP0eFOXiGxR0LG81G6TWIB
         3AzDNmVWsAjN8f8Gb5R2gekA6e7klSuI0SatQDupkpS+ryDbbcm9icll2muKL8kKGP2c
         lOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635812; x=1761240612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6tAVv6b9fRDhntp0ml3AD/e15cFGLUttzwV4nvdq0R8=;
        b=eom3l0k9AJKh/ZDimATchdrIs/YxUxmzhIjGw+jnpcqKcgB70KO/AyL8NwrTvXl/wj
         MG0W5ZOUSgs3o3TLXnTA6puVfc4M/GAplcM8EPo/77DrYhL7319sYccCRzxIQCrlbMVR
         UmFODGFGN4W8DcqT7C6XwMPFqQ5OLu6d17D+pHm4s7gNdPCKcH/qpyT/8ddFpvYdhZG7
         V0R+/646RWRGc0m5gu97PjE4ivneY8Z1vAgtHIVrXpvXraPRcMWD1Fy5kcltbngMKcej
         Htgl9nVH4trgis69/Nd8AQpl7FyGum+30PZPXKKvUMpAzYFuTEKhrlMnXZtf2Z5clOo/
         L/xQ==
X-Forwarded-Encrypted: i=1; AJvYcCXD33gbHjVz4WmQkp44su7fowgt7EpRpboG6DVW41MtMAqp8n4fveSipglwK/Gl/s7Nlieqxk0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHbzg6vtBhDVDrk4b9raqnnels4gG+JZPd2Eor5Z7cBjacs/XT
	iKMsY0YK3F3/6jE3zETKA+u4XcYKTinsooeSG3HI6IOCxVxa4pIio9JiRiNvooE7fjhUsBpAdeL
	8I30r4w==
X-Google-Smtp-Source: AGHT+IFiziQxx4vN6XNlZpR7uI1Y1WkivFjq8+/qZ9wHBFeEPxqCLQgsLYXVUg11kld4O3lt/m0fng8h7Tw=
X-Received: from pji6.prod.google.com ([2002:a17:90b:3fc6:b0:33b:ca21:e3e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e43:b0:339:cece:a99
 with SMTP id 98e67ed59e1d1-33bcf86c699mr779489a91.13.1760635812664; Thu, 16
 Oct 2025 10:30:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:43 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-3-seanjc@google.com>
Subject: [PATCH v13 02/12] KVM: guest_memfd: Add macro to iterate over
 gmem_files for a mapping/inode
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Add a kvm_gmem_for_each_file() to make it more obvious that KVM is
iterating over guest_memfd _files_, not guest_memfd instances, as could
be assumed given the name "gmem_list".

No functional change intended.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .clang-format          | 1 +
 virt/kvm/guest_memfd.c | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/.clang-format b/.clang-format
index f371a13b4d19..220cda77a8f1 100644
--- a/.clang-format
+++ b/.clang-format
@@ -540,6 +540,7 @@ ForEachMacros:
   - 'kvm_for_each_memslot'
   - 'kvm_for_each_memslot_in_gfn_range'
   - 'kvm_for_each_vcpu'
+  - 'kvm_gmem_for_each_file'
   - 'libbpf_nla_for_each_attr'
   - 'list_for_each'
   - 'list_for_each_codec'
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2989c5fe426f..5cce20ff418d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -22,6 +22,9 @@ struct gmem_file {
 	struct list_head entry;
 };
 
+#define kvm_gmem_for_each_file(f, mapping) \
+	list_for_each_entry(f, &(mapping)->i_private_list, entry)
+
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
@@ -164,13 +167,12 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
 static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 				      pgoff_t end)
 {
-	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	enum kvm_gfn_range_filter attr_filter;
 	struct gmem_file *f;
 
 	attr_filter = kvm_gmem_get_invalidate_filter(inode);
 
-	list_for_each_entry(f, gmem_list, entry)
+	kvm_gmem_for_each_file(f, inode->i_mapping)
 		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
 }
 
@@ -189,10 +191,9 @@ static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
 static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 				    pgoff_t end)
 {
-	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	struct gmem_file *f;
 
-	list_for_each_entry(f, gmem_list, entry)
+	kvm_gmem_for_each_file(f, inode->i_mapping)
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
-- 
2.51.0.858.gf9c4a03a3a-goog

