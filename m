Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B875F84F
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 10:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942480; cv=none; b=M2Gis+lh91v0i6BFFdsyUCxt1mGdTg2n5yuV9gTA0wRbY1hP6dr40NpNpg6N5lyXRU8d81PuMP5hcdrPWPRMOmnGWnHvJA5FsDHammYrCgni2HJNCCq3KXoPkZtaAxqkoN/wOKdSWl7M0M22cX7BoVRyMWwWFvEob6fWp4xXh5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942480; c=relaxed/simple;
	bh=GAb9oUO2ju1Qbzt1QBLKzdmcnTJ529at5QJW6z7Afts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VsFbzJNnWHrNEUbwvCd3C7aMHSQDcHDTX/eugcJlAsLl2iv77ZeaUDg9xfyFhYzb2cdJRkc9JqaicB3bslbhWqZ1lyCpBzcxoL73ERiyRQTIXaOXNcL3e3jZtljgknu8TVcmVWbQTwa86n3iA9Qlt8HMj0Mlf+6H8XP4VIvtJk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2476c8a; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2476c8a"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e4f569f326so957037b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 02:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942478; x=1709547278; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nn0wpF++cem/UZGdf5BQR6BIhvfqGjZKC1JKYpLlkg4=;
        b=A2476c8au3eUdjnnecQBvK1syUxkRldDYmAD3/bLJuTS9X9I3q5IEUXYOWTkzmXg4f
         /U1IHj1aibqZsmJ5Cy3f39pB2gmOw1GhGd60UyxH/Ga89fw0Qtr6R5ZUOIl0iI98zpfM
         uKoomAqEzyqEQc9CfQHOcCbrYWqdABzLDm6YBL6Q2xuKcP3wbjhUNpHnJg7So0TkMWHW
         WHUMw4S1epiX0cIZTunX9Vlnv6jzyv7DChKMjObxK3mV/OoCkDj4SoyHDL9nh0G6cv1K
         Iz5+avIoCPdmEOGaHEP43hfsoTSBRKHXYVMb9eBPc9QPHkOGnZNxTOu6Cnoi5Ql5Xyr+
         cG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942478; x=1709547278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nn0wpF++cem/UZGdf5BQR6BIhvfqGjZKC1JKYpLlkg4=;
        b=wQ9e1T3AUX/RuFPimkbSV8sflR9VID1KluIZO/Ngoxbs0O3A0/RyWafe5B0Q44HhB2
         Y5lUl1+NIms+/tsJC/4gtT5ctqhd3qnWXOQU9DB/EbzF0u0lbNgjH0GXFRJt+H154QIa
         VBLUU8cFp/9bXKAzFCqnTQb8xYz0u7jdxJvE6g8dNL509Ky9xqP4BjD4h9viSH+W0cBi
         ahfhGbpRqSAIPG++FvE5QYA3KQsT8t+mf5ozvH5GVkRUXCbIxwL5qMYD2OHwkEiOmY+4
         19LiPWXHViDKf98yvk55CgCiW5mi3+m0TQBdtueGkgt4IYo4IIw6TZn/o//JkGRG7gOF
         Mueg==
X-Forwarded-Encrypted: i=1; AJvYcCXf/2Uv89EqCxlPN/SSGXomkPoH8m2VqJJcYtPCvzf4Kfqd5qwtbs+yUSA6MxYkJbFwEIy/cDD/7EMdk1XjIU53sN7kKyyT
X-Gm-Message-State: AOJu0YzGMC5YdSAbZRmLC2ow2imif6vdurB3M9gPcVPrji7QzozOxs1A
	USoqQlyvR0Eq4hnDD0z/BLkrXmsNKgwo8PtuoaMobnBpXs0F53h5
X-Google-Smtp-Source: AGHT+IEONag+59fDg0rGek6fdriFbxd2o5/eMYAnHfHOB8an4AA/o7Pf8BjvWbqvq5clxGkq4IH8cg==
X-Received: by 2002:aa7:8613:0:b0:6e4:c69f:572b with SMTP id p19-20020aa78613000000b006e4c69f572bmr7009039pfn.27.1708942478503;
        Mon, 26 Feb 2024 02:14:38 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:38 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH 29/32] configure: Fail on unknown arch
Date: Mon, 26 Feb 2024 20:12:15 +1000
Message-ID: <20240226101218.1472843-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

configure will accept an unknown arch, and if it is the name of a
directory in the source tree the command will silently succeed. Make
it only accept supported arch names.

Also print the full path of a missing test directory to disambiguate
the error in out of tree builds.

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Nico Böhr <nrb@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Cc: kvm-riscv@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 configure | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 6907ccbbb..ae522c556 100755
--- a/configure
+++ b/configure
@@ -45,7 +45,8 @@ usage() {
 	Usage: $0 [options]
 
 	Options include:
-	    --arch=ARCH            architecture to compile for ($arch)
+	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
+	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
 	    --processor=PROCESSOR  processor to compile for ($arch)
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
@@ -321,11 +322,15 @@ elif [ "$arch" = "ppc64" ]; then
 elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     testdir=riscv
     arch_libdir=riscv
+elif [ "$arch" = "s390x" ]; then
+    testdir=s390x
 else
-    testdir=$arch
+    echo "arch $arch is not supported!"
+    arch=
+    usage
 fi
 if [ ! -d "$srcdir/$testdir" ]; then
-    echo "$testdir does not exist!"
+    echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
 
-- 
2.42.0

