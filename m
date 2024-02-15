Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67C1145B07
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041254; cv=none; b=q9TmqibgSJoX7p48Yvj4/io5I+Zi3XUViYfawzaufeB9+ri9hiTiRYN0Vd0KjBXUiiKOPz1KsoSz1KVYalalnJfpfhhRSQSGvaWWElIF70CYNVh/0uIdBJHnrzboFJK7aByn/LorHfJJLZj6YFRQum0xGjY4omC8jygphYPzznk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041254; c=relaxed/simple;
	bh=2Gmh2RqGGbogR47nKktVVZKh+hADkkb1APEKMK2y+Ec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EAsZJzVegiMwrpiFN5iUrH7Z09CMQ53WfrQANpxZB1JfvFCpW9qCELz033RnjUaYl0ZWT6W713SuFhoSIZ/aZ6MCrEvzqonXF94aQKVIlYYgNBIojeZIv0qNgqu5Cay955v+9f5hyeAh+6cXXBm6rXlMAZlbBLdyLmmQK7vIBs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XwTP9m0m; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XwTP9m0m"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6047a047f58so24607417b3.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041251; x=1708646051; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SpXI0W6SyqUsN8O3cq60fFq4dAgX1VPZevRlW+M4Y/M=;
        b=XwTP9m0mydb9rdJowWX0O9Br4sSR2PIg/Zx5zgt/UkiEiyW6FC07ZXj+zi0pk0HpnS
         Ve9/uNAadZTJfsPwpICO7qeNZrdlFkDyOtGdGT0/Awr5Lo6UfEave48n+tbB+PYyErTF
         t7I/HA6LrYFFiag9Tqm8MigEUNlX9R1bt1VU9OBFb50tnOvJi7rOShp75EO/OyK0V48f
         NZu1IkAjwDFsD1HXsIIlkox9dZSr15rGM0cDZjfj5DxD5TtQLlD+231zRebxfYCFNDyS
         WXFSL5YQQHspzAMkJJruAGbn8AylbbVAp7xT1a29TT5FrDMKTNbWtKCw0rqG4Y+YtPLl
         +wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041251; x=1708646051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpXI0W6SyqUsN8O3cq60fFq4dAgX1VPZevRlW+M4Y/M=;
        b=d8XamfsGMzoCOaHqol9fZ+5eRjvN01kt/X42r8AQGs+op4DngoKWah1JNL3axI0hai
         gCMW6ZltRNkIuWgVDzEslBKDxuNzpRzahfu6vCl4ZTBCkbVnikMfePbhrLVmo1csxlsI
         6t/7Zs6po3GOqDAVbqZkunNO1dogaHpY2Ftpl5J93oSF93MBj0oBRIyS8sfRDuol3bqi
         7WaLn2YV44NPqAkR2nfp2fslO0LPmJHl06Bd2j6oYoWhQipZQuyWQNjH9bsFOJW7cGf7
         BWlx8sZLqHF3BB5Yf7h7z2khaFT1Qw9cP6UUu16lmdjLMAuMLZ8HijcX1xumJsr69NYo
         ktiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKV6iwEsvBTbKpyMmGDS7rX+TDvofzXGjKYOMb/aqu2vQsCsQkm0QT5qtAew4aia1y40upEDWuR+cEB5e/CgiZuGznNWnG
X-Gm-Message-State: AOJu0YxuHT29lrGr78Ymw/2fH57SNr6Lmr+/6oLoiCVduQwKqm5F+ve/
	EbVWw54lC7M8v8NUCC2D52wQ7LafIQk7xWJe35+KOycCx9aKHeX2EcJz1u+NQ8WW9BSImVf/tG2
	9MZQL271iNQ==
X-Google-Smtp-Source: AGHT+IGZA9+3WHFiYMUlOOAp3pzMgy3+EL2Y42TvoL0DWMZvwKvmW9yoy8cs+q33yE2vXi275sun/QISAhlCzA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:728:b0:dc7:48ce:d17f with SMTP
 id l8-20020a056902072800b00dc748ced17fmr828768ybt.10.1708041251800; Thu, 15
 Feb 2024 15:54:11 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:52 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-2-amoorthy@google.com>
Subject: [PATCH v7 01/14] KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The current description can be read as "atomic -> allowed to sleep,"
when in fact the intended statement is "atomic -> NOT allowed to sleep."
Make that clearer in the docstring.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff588677beb7..46e7b8dbb3d8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2959,7 +2959,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function can sleep
+ * @atomic: whether this function is forbidden from sleeping
  * @interruptible: whether the process can be interrupted by non-fatal signals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
-- 
2.44.0.rc0.258.g7320e95886-goog

