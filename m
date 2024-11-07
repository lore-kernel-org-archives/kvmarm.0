Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F78218D94
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 21:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015708; cv=none; b=TYKlU/+nmGMcgydg/NeVU64zq/jbfr//OQuQ1tzbkcV3Ur5FwAeHL7nvYa4D1NC7C2oVOhvPz3hat4kknVSMaBvym3yssW7P2X6ikitinWki3Li47GIilmKm4qkffeJwG3OVJx4M+d8FIBVUE0QFslrUjMpwZNp0A1VxBAyqexk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015708; c=relaxed/simple;
	bh=r5PBaY2BtyI/IhYtOVfMJDxFChBMs+Kl4IcmdMX9iPM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rrP2c//g8b+6cVqUzOyiN+5SAcmrmDe5KoUQWedrLEQRgU+YnnkrJDoYjLgiOlFTJXtxHxlhCeA5a9GIM1yBNPBY86kV0j4KTiJbfjXWufBHdc1F19PiIO/Dob/QKKe1O7ZBLHsYgvRSylm3YIWd4UIAScfDkv66qBD5Rj0wapg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZN7VnO5c; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZN7VnO5c"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-722531f7806so1717861b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 13:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015707; x=1731620507; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XtpqsepAghjHxA0kDCxZtEi1YPJ/CrW2sXJeZXJ/pOo=;
        b=ZN7VnO5cYd64uXZbnkavZiSCHcQv0+xL46+M7UbMs3yMGqRU0b8AK1asAYuqRbbdRW
         ibJOkUgIkgKOMEITPjLOA1x7c2YVN/AY9rqLdmWOOtqqD1boy+Zx79GgntJclNfHtvBN
         PBgBvveUrkNbZJzJMeVhHU6nfCkqcagHfiYEwTKQniPCXzym89FMD8MSVNts5mZGaOMY
         3vMjeGKpoBEkY9vb5pcrVZI5+OdUnPiTRj4GKX0FKJ0TPriI7C7WHCq1i1Ul8KPlvTN0
         7ZWjhUFojm2AKmTkf6kNkrCJZfLkHGAgwY+FaBzCkVbVJIRHsdEopX8rMqrU7g7+wy5b
         GmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015707; x=1731620507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XtpqsepAghjHxA0kDCxZtEi1YPJ/CrW2sXJeZXJ/pOo=;
        b=BwAm6yGzINxV1WX4OMrjIt7lE/tRKhTDi/DCHU5fL6z6hpuLnjKdPcAI+FE8rOQdrS
         nYHKFfb+ERVy8yHBU5qK2iLz6Ma6j/yv+eg7RaGV3Wyyj/a651rl0Wp7654FM9+e2Cgi
         og+U8BJdcsmHi++nnsLxdN2JejlKjtl8DRIuJ3LwqkRVYlx2OnCc/lioXU7FpWpfdMxJ
         I/7tzKa6VTEDDZJOsExPPx7d0ccb+ATVKc5FXzFsJBRD0Y8lFJYpU/8soA/YeyJuFOjt
         nkQ+ra4CljZeNCzcfW+uTDrT/dFC40DIqKzGZdFZe7NbhkFUZxFYPQMGNKNXPaOSlUj9
         jEQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcdRjQRQbnzu2V6TwQOF1ItrGPIUKSGx1kBMg7xvhTNvQoTxx4W7Xq72tH+eT7POMGVy28gCY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTnsyAhh1+sOrn51KpGrfZYub5JFP6/zW1a/7KGkt8LL2MdWDW
	c9gIdrhlQ5e7dKBoERj/GTKok3z5cH1tHMjzCNkReTJm0O6TQ+Br2jlr5oOF8h6BaWdFxrJAHaH
	cQpRzNKV5Akzk0K0uqb7dsA==
X-Google-Smtp-Source: AGHT+IHw+xM1HlMo/mm9/jXnKYIrDslMzGRFzsHZqSD7GyTGZbxTc8P6vl53dGA2leVXUp61huR9YQcKulFNDJfrGg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:ccb:b0:71e:591d:cb4f with
 SMTP id d2e1a72fcca58-724133eff5emr22007b3a.6.1731015706680; Thu, 07 Nov 2024
 13:41:46 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:36 -0800
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241107214137.428439-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-5-jingzhangos@google.com>
Subject: [PATCH v4 4/5] KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kunkun Jiang <jiangkunkun@huawei.com>

vgic_its_save_device_tables will traverse its->device_list to
save DTE for each device. vgic_its_restore_device_tables will
traverse each entry of device table and check if it is valid.
Restore if valid.

But when MAPD unmaps a device, it does not invalidate the
corresponding DTE. In the scenario of continuous saves
and restores, there may be a situation where a device's DTE
is not saved but is restored. This is unreasonable and may
cause restore to fail. This patch clears the corresponding
DTE when MAPD unmaps a device.

Co-developed-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[Jing: Update with entry write helper]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 9ccf00731ad2..7f931e33a425 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1139,9 +1139,11 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	bool valid = its_cmd_get_validbit(its_cmd);
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
+	int dte_esz = vgic_its_get_abi(its)->dte_esz;
 	struct its_device *device;
+	gpa_t gpa;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
@@ -1162,7 +1164,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * is an error, so we are done in any case.
 	 */
 	if (!valid)
-		return 0;
+		return vgic_its_write_entry_lock(its, gpa, 0, dte_esz);
 
 	device = vgic_its_alloc_device(its, device_id, itt_addr,
 				       num_eventid_bits);
-- 
2.47.0.277.g8800431eea-goog

