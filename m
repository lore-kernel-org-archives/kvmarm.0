Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com [209.85.167.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8A61D6BE
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mwa.re
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mwa.re
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mwa.re header.i=@mwa.re header.b="E8UdRVhV"
Received: by mail-lf1-f65.google.com with SMTP id 2adb3069b0e04-507c5249d55so1578624e87.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 11:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mwa.re; s=google; t=1697827517; x=1698432317; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZfFMOnzOWPDFZoMZUine3Kwx2BGR2wcwPk9fcWx+DPA=;
        b=E8UdRVhVJ3/Ts5Dk355UdRQoogbRWDawV6ZuOpzWSw080u5Qv2MEp+TKROMPWYfTIL
         dWHpGaV0IjXeJQUfhV7lVqT5Fi0SFZC0ee7kBhrUSR4qWg3z3NnqypfKsQaEm9Dk2b9z
         0wUbBuoQwjJVjOzrQiYKu6ygoi2bh25a5PHfNBaOkasqMYvElercrK+4LlspLRN+AzOg
         3YxUPrxDS7F0ufXWwW/+Ytr1EMfw6BuE6JLah3DukWBG1GxeuGR5YbMME9GybONKCdnO
         X0/vU4+AxZ4GmsaBv97I6TSOQx40qvfoPqJi3T+e6Yaz9l43RW9jKGNrqU0Pes4PCppA
         vFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697827517; x=1698432317;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZfFMOnzOWPDFZoMZUine3Kwx2BGR2wcwPk9fcWx+DPA=;
        b=ZrB+DEPEAGEgUCighYn2fBEa7HlIjSSKWHA9vy2MAmhL2xQmfCY0SIRY518U2u7Mlu
         QEg8qoZ+dFJBVgR5mdzkp6WAjcM0Smj9iARovcwxg6a8cTGvWrCEsU15gdFXfkQwxe6W
         rukK06FwEMQTHUOczYX1nKbwZ4feduXUt0yGBTFy5ZNxo2CraVv1tCYqOdlrgnBgFhXh
         gct9EcY1/lhusiHWpNhXJOaThTXxCLW+wJYDXVEPOvyxz/zityfd9DEzv2hLKLjK/E5h
         rK7nvuM9xbQUAQU1DlSTBTufy3hG2JaN/oZBUSpAbob66OA6sqOa6ThVjriFj+pDbOSO
         49Zg==
X-Gm-Message-State: AOJu0YzuHJUfqqZ0EsVZA2e264JuZh1vSH1mNt9n0bG4YRfjQNnk91St
	RyDTcKT7+T4BQYB6oysouIiwmxCQi6Cj4S5TscDe7g==
X-Google-Smtp-Source: AGHT+IE5hZ1sKzwYuMwdSBO+vIOGwPbVFEcae0zzTmXEQmtV9ubV2XfshfdeCHWwUQnmfz7pTCIGDGe4fITdr3PoS58=
X-Received: by 2002:ac2:5a0a:0:b0:4fb:9f93:365f with SMTP id
 q10-20020ac25a0a000000b004fb9f93365fmr1881407lfn.38.1697827516928; Fri, 20
 Oct 2023 11:45:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Jan Henrik Weinstock <jan@mwa.re>
Date: Fri, 20 Oct 2023 20:45:05 +0200
Message-ID: <CANi1PHhzk80HvwQbBM46gpJ6_AA_P6+m5Jo0Nuy_MAdA4C2BhQ@mail.gmail.com>
Subject: KVM exit to userspace on WFI
To: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, =?UTF-8?Q?Lukas_J=C3=BCnger?= <lukas@mwa.re>
Content-Type: multipart/mixed; boundary="00000000000009855e06082a46e7"

--00000000000009855e06082a46e7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

I am looking for a way to have KVM_RUN exit back to userspace once the
vcpu encounters a WFI. It seems the kvm_run->request_interrupt_window
flag is currently ignored by arm64. So my solution thus far is to
patch kvm_handle_wfx in arch/arm64/kvm/handle_exit.c and return to
userspace with KVM_EXIT_IRQ_WINDOW_OPEN - working example attached.
Any chance to get this (or something similar) mainline?

--=20
Dr.-Ing. Jan Henrik Weinstock
Managing Director

MachineWare GmbH | www.machineware.de
H=C3=BChnermarkt 19, 52062 Aachen, Germany
Amtsgericht Aachen HRB25734

Gesch=C3=A4ftsf=C3=BChrung
Lukas J=C3=BCnger
Dr.-Ing. Jan Henrik Weinstock

--00000000000009855e06082a46e7
Content-Type: text/x-patch; charset="US-ASCII"; name="kvm.patch"
Content-Disposition: attachment; filename="kvm.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lnyy9nky0>
X-Attachment-Id: f_lnyy9nky0

ZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FybS5jIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMK
aW5kZXggNTRkMjZmMTNmLi43YmU0MmUzZjEgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL2Fy
bS5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jCkBAIC0yMTUsNiArMjE1LDcgQEAgaW50IGt2
bV92bV9pb2N0bF9jaGVja19leHRlbnNpb24oc3RydWN0IGt2bSAqa3ZtLCBsb25nIGV4dCkKIAlj
YXNlIEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHOgogCWNhc2UgS1ZNX0NBUF9WQ1BVX0FUVFJJQlVU
RVM6CiAJY2FzZSBLVk1fQ0FQX1BUUF9LVk06CisJY2FzZSBLVk1fQ0FQX0FSTV9XRlhfRVhJVDoK
IAkJciA9IDE7CiAJCWJyZWFrOwogCWNhc2UgS1ZNX0NBUF9TRVRfR1VFU1RfREVCVUcyOgpkaWZm
IC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQuYyBiL2FyY2gvYXJtNjQva3ZtL2hh
bmRsZV9leGl0LmMKaW5kZXggYTVhYjUyMTUwLi5kMDM4NmZhZWIgMTAwNjQ0Ci0tLSBhL2FyY2gv
YXJtNjQva3ZtL2hhbmRsZV9leGl0LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQu
YwpAQCAtODgsNiArODgsMTEgQEAgc3RhdGljIGludCBoYW5kbGVfbm9fZnBzaW1kKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkKICAqLwogc3RhdGljIGludCBrdm1faGFuZGxlX3dmeChzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpCiB7CisJaWYgKHZjcHUtPnJ1bi0+cmVxdWVzdF9pbnRlcnJ1cHRfd2luZG93
KSB7CisJCXZjcHUtPnJ1bi0+ZXhpdF9yZWFzb24gPSBLVk1fRVhJVF9JUlFfV0lORE9XX09QRU47
CisJCXJldHVybiAwOworCX0KKwogCWlmIChrdm1fdmNwdV9nZXRfZXNyKHZjcHUpICYgRVNSX0VM
eF9XRnhfSVNTX1dGRSkgewogCQl0cmFjZV9rdm1fd2Z4X2FybTY0KCp2Y3B1X3BjKHZjcHUpLCB0
cnVlKTsKIAkJdmNwdS0+c3RhdC53ZmVfZXhpdF9zdGF0Kys7CmRpZmYgLS1naXQgYS9pbmNsdWRl
L3VhcGkvbGludXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKaW5kZXggODNhMjE4
NWQ5Li4xMDczMjY5ZjIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaAorKysg
Yi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKQEAgLTExMjQsNiArMTEyNCw3IEBAIHN0cnVjdCBr
dm1fcHBjX3Jlc2l6ZV9ocHQgewogI2RlZmluZSBLVk1fQ0FQX1NZU19BVFRSSUJVVEVTIDIwOQog
I2RlZmluZSBLVk1fQ0FQX1MzOTBfTUVNX09QX0VYVEVOU0lPTiAyMTEKICNkZWZpbmUgS1ZNX0NB
UF9TMzkwX1pQQ0lfT1AgMjIxCisjZGVmaW5lIEtWTV9DQVBfQVJNX1dGWF9FWElUIDIyMgogCiAj
aWZkZWYgS1ZNX0NBUF9JUlFfUk9VVElORwogCg==
--00000000000009855e06082a46e7--
