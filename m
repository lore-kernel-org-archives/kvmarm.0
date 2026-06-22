Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4693B813E
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782137667; cv=none; b=oX/q4aX1X7K+xSJz5+MZQjKhsN0XOoJ8joVH/84m30tZCrKykqXIGc94EZa4Ao4xAdukXCk5ThxjcT976uOWbHyEnNKnVipSx//U9ZC56r1+pmnb8zHS5m4DY4xuCiHR8arEvywMNKpKxl9AXYm09B4Bg4lOI3ygnNQqEqQT46g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782137667; c=relaxed/simple;
	bh=AsVvIRM0LiB6uuIor9GeEXofQ5mDv6boraWopSijpi0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UFNLg2cszMqrpSrzfuVmRofYEkQuMZXjivHmx6Bd18e3GwNnHqT08qE2NR08TRLSG2znzUPIHtvahW+/Ngc6Ttm38esszDNO9twAPro0Qpgc8JSw69vdW7sVxteGKwz8PbUO5Y0PRvTVVswssihf7XahWOCBZNGtaa1JWGkh/wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AS1Z+vGU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AS1Z+vGU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782137665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C2lZOSHl7jsAhia0SyyH/6Muj5VDwhnEjjlDeTnLCJo=;
	b=AS1Z+vGUuLqn9V+e9lScBa1CTMvc+mhBQtAgly2lK3prFzQr05qIoz0K9ixFwU7C5WKFFA
	Rzy98iLDxe2J4r/wDyVsN8Im0z0O3CJ+rAB1qxsT6psy7n2R96wI9VUCVQjuQqT/IssVQl
	pZhuLs/lyUKYiVeazbwKsuJWZ++Vouc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-0wAoWxrbO86M4YMjUKGrvw-1; Mon, 22 Jun 2026 10:14:22 -0400
X-MC-Unique: 0wAoWxrbO86M4YMjUKGrvw-1
X-Mimecast-MFC-AGG-ID: 0wAoWxrbO86M4YMjUKGrvw_1782137660
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4623bdcad2fso2789248f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 07:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782137660; x=1782742460;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C2lZOSHl7jsAhia0SyyH/6Muj5VDwhnEjjlDeTnLCJo=;
        b=jZmIByt2gtwYOi3NDy5OXeItxcicCY4zI8B5g1AjBq92qOpwlzePAd8DPT2/HMYE3A
         aRY2lrC6u2JOhJf/DkqRd6nbxKJwxgBdoRdeJTrbYmV+2wK9sXDBlCg/BGoadOkIf5HA
         2Ujv/+oRqIAmPIH2DZk6zMwiyNzZKrfFSNhpEqerrN/A0e1g3IFsxXa25Qjhhtolw4JK
         gos/XnSpM3NX8CIZT6H6jjvkCSNC9Z2NItBI6XRdnTsurCUXbVKsloanJmj5y5TcsGcg
         IkihASV+sRNdBzsYRvr2fGkkVBYdFcZW0uvaok07jG9MgKJFMJxVwulafBmsDBvH3INy
         Yg1g==
X-Forwarded-Encrypted: i=1; AFNElJ/bQUcxXC9lnkHqJBsyoWaKhP/d3pYQTXv599TUltD1dNmKOEsBGBJHvnzTy4m9Mv1uOvuHUm0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcmXq51l31C9kFqRqGZ7kahlFq7MCUt/MeGshyoSdmUTZhT8n1
	MwSoHOqs9n3PMG5Q3s1zROTRVxomiy50JiQdDSHf2d0mv4NIxjuvFni5Sfd4mQ8GyDRqg1QrOFh
	5JEJoVQ3cDaK9K9PrMN/gCLgzjvUgrl0Ihp1UPg0kfYnccFXaJkOszog8BCxUjYeDAw==
X-Gm-Gg: AfdE7cl5p0J3AqQtz1A+0Wa+E27XzBS27KS32bI29MWHw4RK7w05AZIS6LnOfJqVUZw
	HJwxyQLAO6KrIcjm1mVJsS6gyl3x19UwR5knQTBnz09nESUIqpL/3wKG6gkPC2eWAaKklp5f+Io
	GTPpV9X9IegOqPQG7i9s5NIE4aSOkjVKYisDN3OxiLrRF6dVwZcu/N9JeuEfItSz2Bb5rCsV+gW
	MWXmgjD7aLB5jKcIzRSdYWdCOLn8hPBeB3t519GZIpBebc2rlzmXQviqGlp/9pt5QipMOFh7wtU
	wImMx+1kdXtnuEOhVSpu+igccyXKKBEowczi49nO8qBJssOSfVnwc5cRa1Z9Cu3JroMDEXqoyu0
	a1OvKfdxVeNHwGw/EuzX77uKkaS8t/JNxol6E+XfRICT5SRiBAxmNxY64FZ6T
X-Received: by 2002:a05:600c:828a:b0:492:5297:e8a3 with SMTP id 5b1f17b1804b1-4925297f415mr101043395e9.20.1782137660467;
        Mon, 22 Jun 2026 07:14:20 -0700 (PDT)
X-Received: by 2002:a05:600c:828a:b0:492:5297:e8a3 with SMTP id 5b1f17b1804b1-4925297f415mr101042725e9.20.1782137660057;
        Mon, 22 Jun 2026 07:14:20 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49245a69f81sm268598405e9.1.2026.06.22.07.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 07:14:19 -0700 (PDT)
Date: Mon, 22 Jun 2026 16:14:18 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Zenghui Yu <zenghui.yu@linux.dev>
cc: Jiakai Xu <xujiakai2025@iscas.ac.cn>, Shuah Khan <shuah@kernel.org>, 
    Andrew Jones <andrew.jones@oss.qualcomm.com>, 
    Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev, 
    Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
    Oliver Upton <oupton@kernel.org>
Subject: [PATCH] KVM: selftests: fix steal_time for arm64 with host page size
 > 4K
In-Reply-To: <7575a845-a542-4b16-b512-aec3126f97f3@linux.dev>
Message-ID: <335f21e5-493d-012d-b07c-2e48cc2b9aeb@redhat.com>
References: <20260504112808.21276-1-sebott@redhat.com> <7575a845-a542-4b16-b512-aec3126f97f3@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LZZX3LX5YbWlwvvuR3_gFNzW2fy7NO6yNC8-wVMmZCU_1782137660
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed


Fix the following failure when running with 16K host page size:
==== Test Assertion Failure ====
   lib/kvm_util.c:991: vm_adjust_num_guest_pages(vm->mode, npages) == npages
   pid=873 tid=873 errno=0 - Success
      1  0x0000000000405a27: vm_mem_add at kvm_util.c:991
      2  0x000000000040241f: check_steal_time_uapi at steal_time.c:223 (discriminator 7)
      3   (inlined by) main at steal_time.c:539 (discriminator 7)
      4  0x00007fff8b57af3b: ?? ??:0
      5  0x00007fff8b57b007: ?? ??:0
      6  0x0000000000402b6f: _start at ??:?
   Number of guest pages is not compatible with the host. Try npages=4

Fixes: fc240715fc50 ("KVM: selftests: arm64: Fix steal_time test after UAPI refactoring")
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Link: https://lore.kernel.org/kvmarm/7575a845-a542-4b16-b512-aec3126f97f3@linux.dev/T/#u
Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
  tools/testing/selftests/kvm/steal_time.c | 6 ++++--
  1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 76fcdd1fd3cb..cdb81f3ee4b2 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -208,6 +208,7 @@ static void check_steal_time_uapi(void)
  {
  	struct kvm_vm *vm;
  	struct kvm_vcpu *vcpu;
+	unsigned int gpages;
  	u64 st_ipa;
  	int ret;

@@ -220,8 +221,9 @@ static void check_steal_time_uapi(void)
  	};

  	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);
-	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
+	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, 1);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
+	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);

  	st_ipa = (ulong)ST_GPA_BASE | 1;
  	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
-- 
2.54.0

