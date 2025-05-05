Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914231FF1D5
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 10:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746442328; cv=none; b=jCFhLTpw8Cmrv7z5sBhXcGiu18YoTS4cGbFmjYqWZyj1dwdcTz6JoMwqRnC92eYSqXynUjq6MsETqYyYYdC/HP3LcWpr4UOzpWzuhoJDCqJZ8Q+xsZzsovV9XtBeMpVeHmUye17YMxZt5/hvGmY1CYVQl/KgYZd8lVurYL71pbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746442328; c=relaxed/simple;
	bh=Vlie3UBykPG79RG3sSnc4YueVK1Z4cnu1b01uvewe7k=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=j7qosKckvvFKN1MjkaSs8KWdHuomn2FWnQQMcvjJABemQdNUUobZKWs4w200pke7eSyCgY21/nGIJY6CwoLUNI+tHNdpYQccfMCu0pA1ghDihduIXEuwXCrf2cz3ot+32TXWt6slVTxJBXqZH8iihaBA0v8gnOYndr/+uKZLHYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELsZ6dZr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELsZ6dZr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746442325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=rV1XgPNoXlxuVA1alm8N8QB10UHZNje3da5SMs3oTjs=;
	b=ELsZ6dZrkPxVuafkOE5TgGc5icr+GErCOgYFJsLpqtFR3dQl+6fA6fZoIGsX2pHzyHGNbx
	EhmhzOenfNBY4WEf7GD6mpR5hQ39N0xN3CjoC8FKk5271JkdfE2NC5NSjNBYRNS5XLJ2q2
	64wxAOGEt765FUZfCoeJD4RjtHifmHA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-O5DZiWpWNyKAzxxb7ITGCQ-1; Mon, 05 May 2025 06:52:04 -0400
X-MC-Unique: O5DZiWpWNyKAzxxb7ITGCQ-1
X-Mimecast-MFC-AGG-ID: O5DZiWpWNyKAzxxb7ITGCQ_1746442323
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39c184b20a2so1188634f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 03:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746442323; x=1747047123;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sq8oqpkEbt6VQZ1/grnXYkgovjqr9Z/hWjCihFBzl8g=;
        b=BW3oQuvrw5s/JCGUXT5j1eA4tBly3/98rA1gSWP4s9CH6dZ4ym71b+Se69ECt0+fE+
         vOvZ5n/bthDGeCDh157ZnqDMWvvJXm3OCwdLja+FjImMFc4WD3KAGaxEO1w6sm9drV8r
         khXNhrb5f/WV/HUjljoJuSyo6R5ZQOs9CkipAGXXy5xJmNxpfXUE78AK1S+/oKONYhpa
         5Pc3b0F5tLMdJ8nO0gZzyd0cKE7nDvt4yLPrOPzPysQBWz+BeKIbTlw+eIQJMfQvtSoK
         YalXqKeu/xxzwfgxw3ysUGcP+U10FyyGkIgN9ww9pbq0FJIoAxE/kgeFnWsbzE4MBw7m
         7iEA==
X-Forwarded-Encrypted: i=1; AJvYcCVuyOHdi1eGsc9/A5jSiaeHSMtqUSTsnEtV/dzWj3i8l/32Qdtj8V2RJhRQ+SdvdV+PZbtQL5w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx16qYGc5VdW59Xza9Ys/gj/VKEQsvd4/ifUI6ywK5OPoRKtV5v
	pCSYxMv7FDAQ/dNfhXDiuOfOLLRRaECfRg501mk+MNzAPcLZfs7sogVxYJAKM0gvFkLCY3qB19z
	fDtGtJ66e4bRUv/QZ8TrMjylNJdwBobAjdwFpBIdRRwzAg+VMy8Mupg==
X-Gm-Gg: ASbGncvLRtwsjvo9qNaZW3FAI39MZPiAXcWtt8UAyufOTG3C9usapBubRSrQdbsjyan
	4pLc5CE/RLwnbMPbZWcdVKwzP+JyC9+ewYidadvuR/jJw3IUT9kfeBsozhropZRgKYKVtSPOwFL
	XOmyrtf5uvec53xvsp9ityC6d4cUKbbo6kGr6RIoUPToV/3A4Ql2En5LzOXQA2q4ZdGWoNpXPQ8
	fbW4gyPQwDqWrJoJMmOQb0LUSoVC+aJvLWD7OJWkW72oD2uq26oti5M+awQ379WTp5zfa2ug61c
	Dj+1+wnj2XJktP7hL7OemvZbIgror7ovRXaMDbXG7d2mqgcNBqPDRUQEltZo
X-Received: by 2002:a5d:584a:0:b0:39c:1424:2827 with SMTP id ffacd0b85a97d-3a09fd72d2fmr5235993f8f.15.1746442322924;
        Mon, 05 May 2025 03:52:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGavxMvTs7adVpf3ebEvODcNsebFSIFRc5x5LOjIYUhYTGyIAbpQGLg5qpK8yqHQ/F0lIAlRQ==
X-Received: by 2002:a5d:584a:0:b0:39c:1424:2827 with SMTP id ffacd0b85a97d-3a09fd72d2fmr5235976f8f.15.1746442322542;
        Mon, 05 May 2025 03:52:02 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a09a002899sm9624936f8f.0.2025.05.05.03.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 03:52:02 -0700 (PDT)
Date: Mon, 5 May 2025 12:52:00 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
    Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: LM regression: fce886a60207 KVM: arm64: Plumb the pKVM MMU in KVM
Message-ID: <3f5db4c7-ccce-fb95-595c-692fa7aad227@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N4FIrND8ThMDmIXe16L9n6yVznYNHeP5lw3P5PPjP6o_1746442323
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463806286-1042922980-1746442321=:11509"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463806286-1042922980-1746442321=:11509
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hey,

Doing back and forth migrations currently fails on arm after a couple iterations.
During the failing migration KVM_RUN exits via guest_abort and returns -ENOMEM.
I can reliably reproduce this by migrating between 2 qemu instances on an ampere
altra machine. This fails after < 5 iterations. In this case qemu would spit out
smth like this (other than that - nothing in the logs):

error: kvm run failed Cannot allocate memory
  PC=0000aaaae7d48590 X00=0000aaaae80a2e00 X01=0000aaaae7ea2fc0
X02=0000000001d3a5d0 X03=0000aaaae7eace8c X04=000000003b9aca00
X05=000000000000004a X06=000000000000004a X07=0000000028000000
X08=0000000000001d70 X09=0000000000000018 X10=000144b7d0000000
X11=00ffffffffffffff X12=000000008378f367 X13=0000aaab1a202d70
X14=0000000000000000 X15=0000000000000000 X16=0000ffffa2e2f7a8
X17=0000ffffa2541f20 X18=000000000000a000 X19=84bfda6288cf2dd6
X20=0000aaab1a1f1ce0 X21=000000007fffffff X22=0000ffffc5431788
X23=0000aaab1a17db60 X24=0000ffffc5431770 X25=0000000100000000
X26=0000004100000000 X27=0000000000000001 X28=0000aaab1a1f1c20
X29=0000ffffc54316d0 X30=0000aaaae7f8cd24  SP=0000ffffc5431650
PSTATE=20001000 --C- EL0t

Guest and host are otherwise idle, kvm is in normal VHE mode.

Git bisect points to (fce886a60207 "KVM: arm64: Plumb the pKVM MMU in KVM")
I also double checked that by reverting this commit on top of 6.14.

Sebastian
---1463806286-1042922980-1746442321=:11509
Content-Type: text/plain; name=bisect.log
Content-Transfer-Encoding: BASE64
Content-ID: <7f7f94bd-ec02-d458-7ef4-4859ab216191@redhat.com>
Content-Description: 
Content-Disposition: attachment; filename=bisect.log

Z2l0IGJpc2VjdCBsb2cNCiMgYmFkOiBbMzhmZWMxMGViNjBkNjg3ZTMwYzhjNmI1NDIwZDg2ZTgx
NDlmNzU1N10gTGludXggNi4xNA0KIyBnb29kOiBbZmZkMjk0ZDM0NmQxODViNzBlMjhiMWEyOGFi
ZTM2N2JiZmU1M2MwNF0gTGludXggNi4xMw0KZ2l0IGJpc2VjdCBzdGFydCAnYmFkJyAnZ29vZCcN
CiMgZ29vZDogWzJjOGQyYTUxMGMxNWMwMDM3NDllNDNhYzJiOGUxYmM3OWE3YTAwZDZdIE1lcmdl
IHRhZyAnc291bmQtNi4xNC1yYzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC90aXdhaS9zb3VuZA0KZ2l0IGJpc2VjdCBnb29kIDJjOGQyYTUxMGMxNWMw
MDM3NDllNDNhYzJiOGUxYmM3OWE3YTAwZDYNCiMgZ29vZDogWzlmZjI4ZjJmYWQ2N2UxNzNlZDI1
YjhjM2ExODNiMTVkYTU0NDVkMmRdIE1lcmdlIHRhZyAnbG9vbmdhcmNoLTYuMTQnIG9mIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9jaGVuaHVhY2FpL2xpbnV4
LWxvb25nc29uDQpnaXQgYmlzZWN0IGdvb2QgOWZmMjhmMmZhZDY3ZTE3M2VkMjViOGMzYTE4M2Ix
NWRhNTQ0NWQyZA0KIyBiYWQ6IFsyNDM4OTkwNzZjM2VmZGY5OGQ4ZTkyMmE4MDI4OTY0MjRhNTk3
NTgwXSBNZXJnZSB0YWcgJ3J1c3QtZml4ZXMtNi4xNC0yJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvb2plZGEvbGludXgNCmdpdCBiaXNlY3QgYmFkIDI0
Mzg5OTA3NmMzZWZkZjk4ZDhlOTIyYTgwMjg5NjQyNGE1OTc1ODANCiMgYmFkOiBbOTVkN2U4MjI2
MTA2ZTM0NDViMGQ4NzcwMTVmNDE5MmM0N2QyMzYzN10gTWVyZ2UgdGFnICdhdGEtNi4xNC1yYzEt
cGFydDInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9s
aWJhdGEvbGludXgNCmdpdCBiaXNlY3QgYmFkIDk1ZDdlODIyNjEwNmUzNDQ1YjBkODc3MDE1ZjQx
OTJjNDdkMjM2MzcNCiMgYmFkOiBbN2M3NzVjNjA1NmQwN2ViNzc3ZjM3YzdhYzEzNDAxMTViMjdk
YzlmOF0gTWVyZ2UgdGFnICdkbWFlbmdpbmUtNi4xNC1yYzEnIG9mIGdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC92a291bC9kbWFlbmdpbmUNCmdpdCBiaXNlY3Qg
YmFkIDdjNzc1YzYwNTZkMDdlYjc3N2YzN2M3YWMxMzQwMTE1YjI3ZGM5ZjgNCiMgYmFkOiBbN2M3
NzVjNjA1NmQwN2ViNzc3ZjM3YzdhYzEzNDAxMTViMjdkYzlmOF0gTWVyZ2UgdGFnICdkbWFlbmdp
bmUtNi4xNC1yYzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC92a291bC9kbWFlbmdpbmUNCmdpdCBiaXNlY3QgYmFkIDdjNzc1YzYwNTZkMDdlYjc3N2Yz
N2M3YWMxMzQwMTE1YjI3ZGM5ZjgNCiMgYmFkOiBbZjc4NTY5MmZmNTQ1YWVjYjUxN2QyNjA5ODY0
ZTFjNmQ4MzgzMjllNl0gTWVyZ2UgdGFnICdzdG9wLW1hY2hpbmUuMjAyNS4wMS4yOGEnIG9mIGdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9wYXVsbWNrL2xpbnV4
LXJjdQ0KZ2l0IGJpc2VjdCBiYWQgZjc4NTY5MmZmNTQ1YWVjYjUxN2QyNjA5ODY0ZTFjNmQ4Mzgz
MjllNg0KIyBiYWQ6IFswODA2MTJiMjk0MmFiNzk0NzMwMzAyOWUxZmEzMzExN2I1MjgwZWNlXSBN
ZXJnZSBicmFuY2gga3ZtLWFybTY0L252LXRpbWVycyBpbnRvIGt2bWFybS1tYXN0ZXIvbmV4dA0K
Z2l0IGJpc2VjdCBiYWQgMDgwNjEyYjI5NDJhYjc5NDczMDMwMjllMWZhMzMxMTdiNTI4MGVjZQ0K
IyBiYWQ6IFtkMDY3MDEyOGQ0MmZhMTcwYmY4YmE4NzhjZDIzNTA0YzVjNWNjY2M3XSBNZXJnZSBi
cmFuY2gga3ZtLWFybTY0L3Brdm0tbnAtZ3Vlc3QgaW50byBrdm1hcm0tbWFzdGVyL25leHQNCmdp
dCBiaXNlY3QgYmFkIGQwNjcwMTI4ZDQyZmExNzBiZjhiYTg3OGNkMjM1MDRjNWM1Y2NjYzcNCiMg
Z29vZDogW2M0YTZlZDg1NDU1OTc5ZWYzZmJhZGMyZjFiZGYxODczNGIwZWNlYTZdIEtWTTogYXJt
NjQ6IFByb21vdGUgZ3Vlc3Qgb3duZXJzaGlwIGZvciBEQkd4VlIvREJHeENSIHJlYWRzDQpnaXQg
YmlzZWN0IGdvb2QgYzRhNmVkODU0NTU5NzllZjNmYmFkYzJmMWJkZjE4NzM0YjBlY2VhNg0KIyBn
b29kOiBbZDBiZDNlNjU3MGFlZTQyNzY2ZTdiZDg4NDczNGFlMDc4NjY3ZWExZV0gS1ZNOiBhcm02
NDogSW50cm9kdWNlIF9fcGt2bV9ob3N0X3NoYXJlX2d1ZXN0KCkNCmdpdCBiaXNlY3QgZ29vZCBk
MGJkM2U2NTcwYWVlNDI3NjZlN2JkODg0NzM0YWUwNzg2NjdlYTFlDQojIGdvb2Q6IFs3NmYwYjE4
YjNkYjU3ODY4ZmIwY2FiZTY5MTIwMWFhZDMwODViNzEyXSBLVk06IGFybTY0OiBJbnRyb2R1Y2Ug
X19wa3ZtX2hvc3RfbWt5b3VuZ19ndWVzdCgpDQpnaXQgYmlzZWN0IGdvb2QgNzZmMGIxOGIzZGI1
Nzg2OGZiMGNhYmU2OTEyMDFhYWQzMDg1YjcxMg0KIyBnb29kOiBbZTkxMmVmZWQ0ODVhNGM1MGJk
YzM5MzRhZTY0N2UyNTdlZjU2OGVmNl0gS1ZNOiBhcm02NDogSW50cm9kdWNlIHRoZSBFTDEgcEtW
TSBNTVUNCmdpdCBiaXNlY3QgZ29vZCBlOTEyZWZlZDQ4NWE0YzUwYmRjMzkzNGFlNjQ3ZTI1N2Vm
NTY4ZWY2DQojIGJhZDogW2ZjZTg4NmE2MDIwNzM0ZDYyNTNjMmM1YTNiYzI4NWUzODVjYzU0OTZd
IEtWTTogYXJtNjQ6IFBsdW1iIHRoZSBwS1ZNIE1NVSBpbiBLVk0NCmdpdCBiaXNlY3QgYmFkIGZj
ZTg4NmE2MDIwNzM0ZDYyNTNjMmM1YTNiYzI4NWUzODVjYzU0OTYNCiMgZmlyc3QgYmFkIGNvbW1p
dDogW2ZjZTg4NmE2MDIwNzM0ZDYyNTNjMmM1YTNiYzI4NWUzODVjYzU0OTZdIEtWTTogYXJtNjQ6
IFBsdW1iIHRoZSBwS1ZNIE1NVSBpbiBLVk0NCg==
---1463806286-1042922980-1746442321=:11509--

