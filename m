Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412F525A2A7
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875282; cv=none; b=SsfeNuZFATaQGQkPcHFUol/OJcVqlZuXkgXP+PBy9HSofMFfL0D4E9xdqROJKwZgADe4wsZMtUOjpXLDQyA+aUF1QnSVwPyQWQiPW31xOywwiKV509g2ypLgV9pXSn/qpeAlwPoDlCajn1jraunrhIUDtUouxj+hGlrR9y9M1eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875282; c=relaxed/simple;
	bh=D88a6T3cHwEivrt11hcB7FfmUSn6F2rkXBumHlnlYb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nxr4rPHdrouZWtLKXg5A+CeLSxL33GKvPLfgrh9V57bKRdKDDYA1Q3JqNa4Zy0m0GWmmxu8ghG4YfmXoZmpv4S21NDMa+K7zxymrelpNkaN19ARH0/7n03S60zhbJg6Jvl2JBoPgCDoPfrbS1YFZCexRJLh8tksijmPWlxL6HKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4xSXaeVQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4xSXaeVQ"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so9332177a91.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875281; x=1760480081; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5dmbXUVSLKd9bSlEnT0VG6XHvP3bFxOE7VRW3AC7JgU=;
        b=4xSXaeVQ2LUC5LS6yK3NOR0pVxLxfRrpx1TwoMuEfnePkfK+rdwShN9QTpn7Yti8Np
         osNGl/awjDBiy5Vn2Lsj3lNBSIOibs05EIiwT5SyY2IpYqWL35PPCWhVrZezWImUhQ4u
         Ad1Rbqe3rYm8xlTuvJCMYIook+FphVgWD7vcG2tqXmc1es47HfNpiRJXL9r5VnAtuRim
         rqFwBkIuLHImPeFFguxyRDMyDvhjua8BZ6NPhnPdkJo8EmC4WvXhlwfaM3UCCg6o48E5
         jl9S67oZhlF0eHwk4+zETx2/FY+UB85auEooYJW4eMI9ZmfTD3HmrmysuQJV4RlmoJyf
         4vlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875281; x=1760480081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5dmbXUVSLKd9bSlEnT0VG6XHvP3bFxOE7VRW3AC7JgU=;
        b=NZlwtqeh4J/5idxxj5O/C/WxHnNfn/84Uxk0qGyGkBYFgI2nYioLkcAVc4PmuDkNRY
         TUlljmCmwozVXN4UqyozOGfZ+PDZ9JWCP/DGElfKnUse56/u3DxTqZuvajytSNTq1jbd
         PMC/nAQ8NnmUWBN9kOhqTOL+DIpPkw9CP68bBDTVANprYVeVyCdTzHMyKzLMgHdWtFPT
         xwfMvZicr63aTbZxjGX8UTX2gKk3D0rhU21cT5Z2PQK+hOMYrXMs/CGhFHdiSEhlVqGk
         SqU/Dxz8q1CGCcAcjVzpL0z5V6p0G6bBye8a3jbQHpMVJgjpO5Rb2/rgfNavlsqRA9ps
         9XlQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7Wk3wCU/kjcrYA2x5YnLbIJWTAR87SwasQlWbJfRFCM+/V/XzKcc87an/BMmywMUNGNX5wfM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWVI9no7F+LHayXfwLfpzBHDdNotSnbrRIV+uX5uPq0CB5l6y/
	aGoDwCAasJ7i6SKFEyjcVHThy8U6jxWwkBEg99GL53zjtZVQwDXNMkIJV6YSXiBZQdiYZOpNIXO
	llqd7yw==
X-Google-Smtp-Source: AGHT+IFtELfPuC1E9Gi/gZ0IIwRTquQz/eR0bBtgh0yn3iXudV5xJa4KSH0/8AxoiBoCF/S9YIizGIBH2jI=
X-Received: from plow6.prod.google.com ([2002:a17:903:1b06:b0:290:28e2:ce51])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f602:b0:274:9dae:6a6d
 with SMTP id d9443c01a7336-290272c1a67mr16678315ad.34.1759875280674; Tue, 07
 Oct 2025 15:14:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:10 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-3-seanjc@google.com>
Subject: [PATCH v12 02/12] KVM: guest_memfd: Add macro to iterate over
 gmem_files for a mapping/inode
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Add a kvm_gmem_for_each_file() to make it more obvious that KVM is
iterating over guest_memfd _files_, not guest_memfd instances, as could
be assumed given the name "gmem_list".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3c57fb42f12c..9b9e239b3073 100644
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
@@ -159,13 +162,12 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
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
 
@@ -184,10 +186,9 @@ static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
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
2.51.0.710.ga91ca5db03-goog

