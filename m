Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0544756BB
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933126; cv=none; b=E7O1NYm1XfTDMO3tbCrPhBhQu/JGMNO3IYB7SkPV1KG7WRCqa5ej4CYITqu3LEfUHoBLaHv3AFK47XHYp1+dJOMB9d9l5RuYcPix+6suUPa6jRzoXUzOQH1B7H7xTcTFAjAYmIIIDgDlwFf61z52PRZ75kfB0X8b+eseuIYwfiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933126; c=relaxed/simple;
	bh=SdLMnrBeX+lkpZun39ioJ7bZw8q/M2fEGvYqSVRcl4k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chk886kFgQ3aYzlgwOCH/zEy++KkXr0QxXelhTE7/pk2a5gk9UPCTQXOo6WiAr9VqlfyhoNcJQ1uVYIThN/Tk5waXwsXqyTL6KJfbusuKTe0HUIGfwiYp8OVhMW2PigVY+8PSSqTTa+elyVaiUEFjDMozSnVGdsgkyXTST1xe9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=T87SYyvP; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="T87SYyvP"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43ac6072so20937657b3.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933122; x=1790537922; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=748fu/RuSuWEHxLL4+C7te7l41PPhxbrrdqn5kAp7do=;
        b=T87SYyvPHz70WEy6tshlgOJm6UuWVrIejPjW4Al7kovnYGDyr8SpTLaCm3JY/efVzQ
         5xfSa8o1IXXqZ6aJpT9sjNwez2wlSMwlPmOal8tD/5i3SJqyMMek2qLsuz8L1yW3Plgl
         2tR/pt9mISnuRNqK6Cv8CshTR76DpcQSCNEVEhXfd3d0L3PQLmPknhoi0j1WfmYsFXCD
         nx6iDDZDCe2PlfwY6gZvtDTgINaozTxekbDi6T509tgqRiJgVrCnhZodKJO54LW1Mk7Z
         UhXo/86CT9mTvQ3UHLjniAUEQ/zZNWfnAdOIUU2JYX9KcQ974+7ujuAoAveKA9sZtXn9
         QuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933122; x=1790537922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=748fu/RuSuWEHxLL4+C7te7l41PPhxbrrdqn5kAp7do=;
        b=sw+8YPrZo/JLW77mh59owHBh7peVXXJ0gCIVichGEyO1hHM3Tmp+PdGUHxNIr3rlJy
         j4l4W56anrzYe1cWMFN1cV1N9/+SoFLs82QiJZu6n3I7WNaf3QSon+BIsKF7HseeS1Zc
         XJBvXUQkRk7MMWSnZKknBNle58JwwTvt/fy8rCBwoH7BOGdKOzawKmnI0sY45JMkSIrn
         p0aS9GD4NvNS3s2anLfcoPpD7fgyydCue4LFO/tyzXzHRh6YMKqIb/AEgH7noPGq5Tww
         7Kxd+wUr1U/xKhtpueIYmkRIRKYFXdJAnXLtZ32QCawbIsEXTKbGTfp6Q+OORP2pBdtR
         iXEg==
X-Forwarded-Encrypted: i=1; AKwUvByDgBJcO8cYxPQeibvYSIJWvEQC6S5JOxrpYgvPOyVrWfA1l2wLGTkCgFJobC9rOCxYeWr0HxU=@lists.linux.dev
X-Gm-Message-State: AFuF++nSqBUvjwd+PiBP2jevTTpeWvQ+F8TiaM1FpFbxCZMmoMdn2iWa
	ez230YVX7SiW2zmFLDZnNnurOnsuQJP8l9vonlRiK+hyvIMhyRCROkP46XdpbO22KfQ=
X-Gm-Gg: AYBFou0gFnv+L3ELhmnqOtNsVI0soqHJwQ+V/wOmq6oGUwzQSZD1tXhKpCBWlHNivPj
	quSqxUl/PviQbw/EJpzDvf46P2ROFBK79/o/eO2dz347LEvL37sE/tDl5BXQS+S9q57kAsReWUr
	b2UwxKjGyeydl4oeOGNZCbNIWDsu2cCKWMmven3QiiaVYF/kxEd/nOKOv3zwn0mJLIR1a7GIZmw
	gZ5xtaKUL9NaJMihEdDS4cyXPBRQHET2+Wa6extWWXGIsvRqfX54YET0zmk5Gce56Zd9CT1DwrL
	0eGs/N2ytRQv1Uo42HiIdBcCo6S5eo6clLK1WyF1hp9hQw1wz34CfCgsgQS05ePotOq4n0Nca5Q
	g6GeJABhXZOD7PkuUj21Mto5SN6vM2jSKIynPTCfsrntJkxNnOoQCwGp9O+/saEu1s93+qRpLzJ
	C3Wm4rzFWckIl769z+mCmX8JOJ9SSAny5qF2gOBzRRSmXxmcBUyI4zMdh20W/fwmV1qaery5iSE
	zdiO9t1UKWL0DOc9JFnoc00M4AbJ2594Jz1ateGWn6mkf9cT8mFIUy9cIeVw8oL467q9JdOfcxu
	W4mKkMXaS2l236Te3QRFSTGzo5AZsi4=
X-Received: by 2002:a05:690c:6a0d:b0:857:f33:6f1d with SMTP id 00721157ae682-897311d51a6mr25294217b3.6.1789933121962;
        Sun, 20 Sep 2026 12:38:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a41521d6csm18803647b3.1.2026.09.20.12.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:41 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 18/46] liveupdate: cpu_preserve: Add LUO file handler for preserved physical CPUs
Date: Sun, 20 Sep 2026 15:36:22 -0400
Message-ID: <20260920193650.3373435-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the LUO file handler (cpu_preserve_handler) and early boot
incoming CPU adoption for /sys/devices/system/cpu/cpuX/preserve fds.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/cpu_preserve.c | 189 ++++++++++++++++++++++++++++++-
 1 file changed, 185 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
index 2f92dfee82b1..9a039ba9e912 100644
--- a/kernel/liveupdate/cpu_preserve.c
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -837,8 +837,10 @@ void __cpu_preserved_text cpu_preserved_set_dead(int cpu)
 {
 	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
 
-	if (ser)
-		WRITE_ONCE(ser->workload, CPU_PRESERVED_DEAD);
+	if (ser) {
+		smp_store_release(&ser->workload, CPU_PRESERVED_DEAD);
+		cpu_preserved_clean(ser);
+	}
 }
 EXPORT_SYMBOL_GPL(cpu_preserved_set_dead);
 
@@ -1097,8 +1099,6 @@ void __cpu_preserved_text cpu_preserved_park_loop(int cpu)
 		switch (READ_ONCE(ser->workload)) {
 		case CPU_PRESERVED_EXITING:
 		case CPU_PRESERVED_DEAD:
-			WRITE_ONCE(ser->workload, CPU_PRESERVED_DEAD);
-			cpu_preserved_clean(ser);
 			return;
 		case CPU_PRESERVED_WORKLOAD:
 			cpu_preserved_run_workload(ser, pcpu);
@@ -1131,6 +1131,7 @@ void cpu_preserved_park(int cpu)
 	} else {
 		cpu_preserved_park_loop(cpu);
 		arch_cpu_preserved_park_finish(cpu);
+		cpu_preserved_set_dead(cpu);
 	}
 }
 EXPORT_SYMBOL_GPL(cpu_preserved_park);
@@ -1498,6 +1499,171 @@ static struct liveupdate_flb cpu_preserved_flb = {
 	.compatible = CPU_PRESERVED_LUO_FLB_COMPATIBLE,
 };
 
+/*
+ * LUO File Handler Callbacks for /sys/devices/system/cpu/cpu<N>/preserve
+ */
+static int file_to_cpu(struct file *file, unsigned int *cpup)
+{
+	struct dentry *dentry, *parent;
+	unsigned int cpu;
+
+	if (!file || !file->f_path.dentry)
+		return -EINVAL;
+
+	if (file_inode(file)->i_sb->s_magic != SYSFS_MAGIC)
+		return -EINVAL;
+
+	dentry = file->f_path.dentry;
+	if (strcmp(dentry->d_name.name, "preserve"))
+		return -EINVAL;
+
+	parent = dentry->d_parent;
+	if (!parent || sscanf(parent->d_name.name, "cpu%u", &cpu) != 1)
+		return -EINVAL;
+
+	if (cpu >= nr_cpu_ids || !cpu_possible(cpu) ||
+	    !cpu_is_hotpluggable(cpu)) {
+		return -EINVAL;
+	}
+
+	*cpup = cpu;
+	return 0;
+}
+
+static bool cpu_preserve_can_preserve(struct liveupdate_file_handler *handler,
+				      struct file *file)
+{
+	unsigned int cpu;
+
+	return IS_ENABLED(CONFIG_LIVEUPDATE_ONCORE) && file_to_cpu(file, &cpu) == 0;
+}
+
+static int cpu_preserve_preserve(struct liveupdate_file_op_args *args)
+{
+	struct cpu_preserved_file_ser *fser;
+	unsigned int cpu;
+	int ret;
+
+	ret = file_to_cpu(args->file, &cpu);
+	if (ret)
+		return ret;
+
+	ret = cpu_preserve(cpu);
+	if (ret)
+		return ret;
+
+	fser = kho_alloc_preserve(sizeof(*fser));
+	if (IS_ERR(fser)) {
+		cpu_unpreserve(cpu);
+		return PTR_ERR(fser);
+	}
+
+	memset(fser, 0, sizeof(*fser));
+	fser->cpu = cpu;
+
+	scoped_guard(mutex, &cpu_preserved_lock)
+		fser->stack_pa = cpu_preserved_outgoing.pcpus[cpu].stack_pa;
+
+	args->serialized_data = virt_to_phys(fser);
+	return 0;
+}
+
+static void cpu_preserve_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct cpu_preserved_file_ser *fser;
+	unsigned int cpu;
+
+	if (!args->serialized_data)
+		return;
+
+	fser = phys_to_virt(args->serialized_data);
+	cpu = fser->cpu;
+
+	cpu_unpreserve(cpu);
+
+	kho_unpreserve_free(fser);
+}
+
+static void cpu_preserve_restore_incoming_cpu(struct liveupdate_session *session,
+					      struct cpu_preserved_file_ser *fser)
+{
+	unsigned int cpu = fser->cpu;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		cpumask_set_cpu(cpu, &cpu_preserved_incoming.mask);
+		cpumask_set_cpu(cpu, &cpu_preserved_mask);
+
+		if (!cpu_preserved_incoming.pcpus) {
+			cpu_preserved_incoming.pcpus =
+				kcalloc(nr_cpu_ids,
+					sizeof(*cpu_preserved_incoming.pcpus),
+					GFP_KERNEL);
+			WRITE_ONCE(cpu_preserved_host_pcpus_va,
+				   cpu_preserved_incoming.pcpus);
+			cpu_preserved_clean(&cpu_preserved_host_pcpus_va);
+		}
+
+		if (cpu_preserved_incoming.pcpus)
+			cpu_preserved_incoming.pcpus[cpu].stack_pa = fser->stack_pa;
+
+		cpu_preserved_clean(&cpu_preserved_mask);
+	}
+}
+
+static int cpu_preserve_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct cpu_preserved_file_ser *fser;
+	struct file *file;
+	char path[64];
+
+	if (!args->serialized_data)
+		return -EINVAL;
+
+	fser = phys_to_virt(args->serialized_data);
+
+	snprintf(path, sizeof(path),
+		 "/sys/devices/system/cpu/cpu%u/preserve", fser->cpu);
+	file = filp_open(path, O_RDONLY, 0);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	args->file = file;
+	cpu_preserve_restore_incoming_cpu(args->session, fser);
+	cpu_preserved_detach_workload(fser->cpu);
+
+	return 0;
+}
+
+static void cpu_preserve_finish(struct liveupdate_file_op_args *args)
+{
+	struct cpu_preserved_file_ser *fser;
+
+	if (!args->serialized_data)
+		return;
+
+	fser = phys_to_virt(args->serialized_data);
+	if (args->retrieve_status <= 0)
+		cpu_preserve_restore_incoming_cpu(args->session, fser);
+
+	cpu_unpreserve(fser->cpu);
+
+	kho_restore_free(fser);
+}
+
+static const struct liveupdate_file_ops cpu_preserve_file_ops = {
+	.can_preserve = cpu_preserve_can_preserve,
+	.preserve     = cpu_preserve_preserve,
+	.retrieve     = cpu_preserve_retrieve,
+	.unpreserve   = cpu_preserve_unpreserve,
+	.finish       = cpu_preserve_finish,
+	.owner        = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler cpu_preserve_handler = {
+	.ops        = &cpu_preserve_file_ops,
+	.compatible = CPU_PRESERVED_LUO_FH_COMPATIBLE,
+};
+
 static int cpu_preserve_reboot_notify(struct notifier_block *nb,
 				      unsigned long action, void *data)
 {
@@ -1555,6 +1721,21 @@ static int __init cpu_preserve_early_init(void)
 	cpu_preserved_incoming.pcpus_ser = NULL;
 	cpu_preserved_global_ser = NULL;
 
+	err = liveupdate_register_file_handler(&cpu_preserve_handler);
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register cpu_preserve file handler: %pe\n",
+		       ERR_PTR(err));
+		return err;
+	}
+
+	err = liveupdate_register_flb(&cpu_preserve_handler,
+				      &cpu_preserved_flb);
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register cpu_preserved FLB: %pe\n",
+		       ERR_PTR(err));
+		return err;
+	}
+
 	/* Retrieve incoming preserved CPUs before secondary CPU bringup */
 	if (liveupdate_enabled())
 		liveupdate_flb_get_incoming(&cpu_preserved_flb, &obj);
-- 
2.55.0.1082.g2b9226bbc0-goog

