Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A1D435503
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 12:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785240709; cv=none; b=XawRRnrjXVcLzq0cmwD9e17dJu0i/oRH+v3W5yuDK9yYBzUPZ+Z31Qi/qMmO+EYp9u41eFqR1j15+uWJudrlyyNX7GfE3/HDYO3sDag7Z3h+RsHB81PWgI8sTxqaziQqjPk1MwvC4VE6ON+d/1M5K4PUIu9Lb0CR+iQdBczdl9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785240709; c=relaxed/simple;
	bh=SHIy8aufCVUjYH99A1TRISaapb7ROtZzP7MZouZD/Bs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kQz5eT0DmB80p/Q9A3U8rXWrDoA+8p1LyB5miOcM/eVlm1leFc5b+CBDg16GjhcndqSNNYkxm0AUy9/9vHaBxmMMA0TFHKZk4rWYsfTKDd9maYabi3Dzmhoh8bUVlQhaXNmcLS4PLVrk7AK/yUtd8tdjA3sDhDSa8b1BrgMd1rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A5VLbs1q; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A5VLbs1q"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15f4732dfaso424233366b.3
        for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 05:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240706; x=1785845506; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9QAs69nEaOS4rmhD2Q9ekgaAb43dU/I2zqcKzZYHR6c=;
        b=A5VLbs1q0RZqaEByUbb4exByKV3MYQKPwu4o884zdyGIqOaPQ4lXMd817MedEk/Slj
         rARf5ORCdtOXzEL5rJRSyXa/xKl5EsVGMnCWL5jiBaKwJlADJ7JXVF+mSR2Zkac0TVFf
         cCkA0lqdKBufFgdWqQvwRawyZ0AhdNqzIger6644+6XxTjlASLTWgW9LIRm0YtZOlt5C
         EMrX378wnxVxU3sv8aPEjdhkQ360Qmys74Wye09ZPMVVnmKn26V0SGAP6jd2vhP1JM76
         g1sPwyGVf5R5fWpH/yndaKWliDe+MoO0zJ5sYGiVInjAgYexHZCU20EondnVR2Y+VnBH
         g+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240706; x=1785845506;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9QAs69nEaOS4rmhD2Q9ekgaAb43dU/I2zqcKzZYHR6c=;
        b=lRf6uwHyr8D9H3X5uFeny/rIF91yUHK3fcEgqXDiVOUiCgHhekBIcVbzbS7SVN47PY
         LuPEOkymc3GlCAj6A1T3RPcj8BaTMgWUzhAeZlJZ8LQq9Tr3FOOW0f+AxutCiXLjK7/b
         mc7oEdsnXWZkJaMvu9ByDv5LiFGD36j2skAg53ynHm7bvagSdQGH2o0jueTAPA2aYyqO
         0Kd9RGt+Q0lgkEfE5l57g0I6LpjisfeJ207TJ6gdhqZq7sqbT3EiL5UFYHl+Jy8JRMmB
         wplH+aeFtHuw5w68C7w9/yLoLYY1IrU3r4Wy64UTk+ipv2bbJgMummoAFylpyPYkLpE+
         tYqw==
X-Forwarded-Encrypted: i=1; AHgh+RpYFCcK2k3Ja+Kn6XbgY0+XbaNRiPC32vB/KAXif+LdTX2RzG2rYF9hqlDtpxp/8NWyl5qvmp4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3Acbl9xqdZPxH0+uNGXZIVUQ/aDoDK6gDYKKESyi0hUzwuMWG
	Y4EhW1ieNfLwrNsCYQftA8pfed421HHo8XCgzTZK7xMB7SBCckgKMYdd4jJ51Nfa0j+q9GZvJag
	B8biFlQmDQbkeH+My9w==
X-Received: from ejit16.prod.google.com ([2002:a17:906:3e50:b0:c15:8b2e:2c2a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3f96:b0:c12:96af:acf7 with SMTP id a640c23a62f3a-c1f7215156cmr114258866b.43.1785240705336;
 Tue, 28 Jul 2026 05:11:45 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:31 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-5-tarunsahu@google.com>
Subject: [PATCH v4 04/11] KVM: Track weak reference to vm_file in struct kvm
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

- Add a weak reference 'vm_file' in struct kvm under
  CONFIG_LIVEUPDATE_GUEST_MEMFD to enable reverse file resolution
  without circular lifetime dependencies.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kvm_host.h | 12 ++++++++++++
 virt/kvm/kvm_main.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d9908c19e42f..8da9589425ee 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -874,6 +874,18 @@ struct kvm {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
+#endif
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Weak reference to the VFS file backing this KVM instance. Stored
+	 * without incrementing the file refcount to prevent a circular lifetime
+	 * dependency (since file->private_data already pins this struct kvm).
+	 * Used exclusively to resolve the file pointer back from struct kvm.
+	 *
+	 * Written/cleared via rcu_assign_pointer() and read locklessly under
+	 * RCU (e.g. via get_file_active() to prevent ABA races).
+	 */
+	struct file __rcu *vm_file;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 701d4596a91c..14c32541ae34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1346,6 +1346,19 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = filp->private_data;
 
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Clear the weak reference of the vm file.
+	 * In case vm file is closed by userspace, but kvm still has
+	 * other users like vCPUs, clearing this pointer ensures
+	 * that we don't have a dangling pointer to a closed file.
+	 *
+	 * Cleared via rcu_assign_pointer() to ensure proper memory visibility
+	 * for concurrent lockless readers under RCU.
+	 */
+	rcu_assign_pointer(kvm->vm_file, NULL);
+#endif
+
 	kvm_irqfd_release(kvm);
 
 	kvm_put_kvm(kvm);
@@ -5488,6 +5501,19 @@ struct file *kvm_create_vm_file(unsigned long type, const char *fdname)
 		return file;
 	}
 
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Weak reference to the file (without get_file()) to prevent a circular
+	 * dependency. Safe because the file's release path clears this pointer
+	 * and drops its reference to the VM.
+	 *
+	 * Written via rcu_assign_pointer() because the pointer can be read
+	 * locklessly under RCU (e.g., in kvm_gmem_luo_preserve() via
+	 * get_file_active() to prevent lockless ABA races).
+	 */
+	rcu_assign_pointer(kvm->vm_file, file);
+#endif
+
 	/*
 	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
 	 * already set, with ->release() being kvm_vm_release().  In error
-- 
2.55.0.229.g6434b31f56-goog

