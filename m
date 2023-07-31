Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AE818AEF
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 13:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3DCC433CC;
	Mon, 31 Jul 2023 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690811512;
	bh=38AeaFL37vV9MyUQ5JVKuM1gVCMvtkdVnDbNL3TTQpU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qXoeRFLMwwXBpDHEWa1gDstWXEEHjUcKFQ0iBfCJF2J1w6lcePBo/i6CFeI9Y5QVw
	 GVJvkYFg05z6AIECrkSeve9cLXOqlYt0kz+8w064UlspHZkXH/XaawvmKRq2hWPc8Z
	 et4Gq7xTDU8PBiesJLn6Tf2powPoFSO9Fb6sNqIp1XRmXacYZq/5dxBAmPv0uO9kuF
	 Vxyu8Rs/4n5DM9RDgeztpMUTPDR2Cu+29akc7H14VtcOWvW+JsZIpiX88HA89Iid+i
	 7qdIOpWxhQCKWHZpGNSPN/zYk8IAXsVKjIW8z/xPnKA8fUCTNyPPIOTvHUAQCQtH6I
	 63sqWGnRy9cCg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 31 Jul 2023 14:43:19 +0100
Subject: [PATCH v3 10/36] mm: Define VM_SHADOW_STACK for arm64 when we
 support GCS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230731-arm64-gcs-v3-10-cddf9f980d98@kernel.org>
References: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
In-Reply-To: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, 
 Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
 Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, 
 "Rick P. Edgecombe" <rick.p.edgecombe@intel.com>, 
 Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2027; i=broonie@kernel.org;
 h=from:subject:message-id; bh=38AeaFL37vV9MyUQ5JVKuM1gVCMvtkdVnDbNL3TTQpU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkx7wc+fxQLx5AMos/eVhTjWc+kjOb8LaCH/tyLrqi
 Eph2tqWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZMe8HAAKCRAk1otyXVSH0J1LCA
 CGe3cA/HGImzb2h80srHaycpVWYUNkTTKJs5IlcA/d3k+PrXURJAKmJvdRi6ZLVPNZ5XWjFIiVpb69
 0KZ4xEb8L2bsjrvc6dxtiON2Z6Js7joQzDwH87E06xwBZqAktGUNHUBYFljhSCkpO9GFmhm+2spmMj
 8X4k0CTdl+z/4wUScg15dN73TuZK2imHZ8uzOpS5bBJ0QJKBPN0YbpzWdbehgpwonxUOeSfR8D6Cak
 Jeda+JA/v8A1cOTZq2iTG0Emh7FnW1JKSaEUJ1t7e0rTAKFEO6RJLp+kwYC0ILj8LpsMhL7A7OUzN2
 XbVFnL7eKd5md/Eesl2Of3cxn+YO92
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Use VM_HIGH_ARCH_5 for guarded control stack pages.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/filesystems/proc.rst |  2 +-
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 12 +++++++++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 6ccb57089a06..086a0408a4d7 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -566,7 +566,7 @@ encoded manner. The codes are the following:
     mt    arm64 MTE allocation tags are enabled
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
-    ss    shadow stack page
+    ss    shadow/guarded control stack page
     ==    =======================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cfab855fe7e9..e8c50848bb16 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -711,6 +711,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 #ifdef CONFIG_X86_USER_SHADOW_STACK
 		[ilog2(VM_SHADOW_STACK)] = "ss",
+#endif
+#ifdef CONFIG_ARM64_GCS
+		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
 	};
 	size_t i;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 43fe625b85aa..3f939ae212e5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -372,7 +372,17 @@ extern unsigned int kobjsize(const void *objp);
  * having a PAGE_SIZE guard gap.
  */
 # define VM_SHADOW_STACK	VM_HIGH_ARCH_5
-#else
+#endif
+
+#if defined(CONFIG_ARM64_GCS)
+/*
+ * arm64's Guarded Control Stack implements similar functionality and
+ * has similar constraints to shadow stacks.
+ */
+# define VM_SHADOW_STACK	VM_HIGH_ARCH_5
+#endif
+
+#ifndef VM_SHADOW_STACK
 # define VM_SHADOW_STACK	VM_NONE
 #endif
 

-- 
2.30.2

