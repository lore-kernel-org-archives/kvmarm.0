Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89624C25B0E
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43DA14C491;
	Tue,  9 Aug 2022 05:15:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PYIViiRD57AN; Tue,  9 Aug 2022 05:15:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C91204CA08;
	Tue,  9 Aug 2022 05:15:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6D974C47F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vp7mvJi59YY3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C57BE4C9DD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46ABA23A;
 Tue,  9 Aug 2022 02:15:46 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 654393F67D;
 Tue,  9 Aug 2022 02:15:44 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 13/19] arm: page.h: Add missing libcflat.h
 include
Date: Tue,  9 Aug 2022 10:15:52 +0100
Message-Id: <20220809091558.14379-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SW5jbHVkZSBsaWJjZmxhdCBmcm9tIHBhZ2UuaCB0byBhdm9pZCBlcnJvciBsaWtlIHRoaXMgb25l
OgoKL3BhdGgvdG8va3ZtLXVuaXQtdGVzdHMvbGliL2FzbS9wYWdlLmg6MTk6OTogZXJyb3I6IHVu
a25vd24gdHlwZSBuYW1lIOKAmHU2NOKAmQogICAxOSB8IHR5cGVkZWYgdTY0IHB0ZXZhbF90Owog
ICAgICB8ICAgICAgICAgXn5+ClsuLl0KL3BhdGgvdG8va3ZtLXVuaXQtdGVzdHMvbGliL2FzbS9w
YWdlLmg6NDc6ODogZXJyb3I6IHVua25vd24gdHlwZSBuYW1lIOKAmHBoeXNfYWRkcl904oCZCiAg
IDQ3IHwgZXh0ZXJuIHBoeXNfYWRkcl90IF9fdmlydF90b19waHlzKHVuc2lnbmVkIGxvbmcgYWRk
cik7CiAgICAgIHwgICAgICAgIF5+fn5+fn5+fn5+CiAgICAgIHwgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn4KWy4uXQovcGF0aC90by9rdm0tdW5pdC10ZXN0
cy9saWIvYXNtL3BhZ2UuaDo1MDo0NzogZXJyb3I6IHVua25vd24gdHlwZSBuYW1lIOKAmHNpemVf
dOKAmQogICA1MCB8IGV4dGVybiB2b2lkICpfX2lvcmVtYXAocGh5c19hZGRyX3QgcGh5c19hZGRy
LCBzaXplX3Qgc2l6ZSk7CgpUaGUgYXJtNjQgdmVyc2lvbiBvZiB0aGUgaGVhZGVyIGFscmVhZHkg
aW5jbHVkZXMgbGliY2ZsYXQgc2luY2UgY29tbWl0CmEyZDA2ODUyZmU1OSAoImFybTY0OiBBZGQg
c3VwcG9ydCBmb3IgY29uZmlndXJpbmcgdGhlIHRyYW5zbGF0aW9uCmdyYW51bGUiKS4KClNpZ25l
ZC1vZmYtYnk6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4KLS0t
CiBsaWIvYXJtL2FzbS9wYWdlLmggfCAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvbGliL2FybS9hc20vcGFnZS5oIGIvbGliL2FybS9hc20vcGFnZS5o
CmluZGV4IDhlYjRhODgzODA4ZS4uMGE0NmJkYTAxOGM3IDEwMDY0NAotLS0gYS9saWIvYXJtL2Fz
bS9wYWdlLmgKKysrIGIvbGliL2FybS9hc20vcGFnZS5oCkBAIC04LDYgKzgsOCBAQAogCiAjaW5j
bHVkZSA8bGludXgvY29uc3QuaD4KIAorI2luY2x1ZGUgPGxpYmNmbGF0Lmg+CisKICNkZWZpbmUg
UEFHRV9TSElGVAkJMTIKICNkZWZpbmUgUEFHRV9TSVpFCQkoX0FDKDEsVUwpIDw8IFBBR0VfU0hJ
RlQpCiAjZGVmaW5lIFBBR0VfTUFTSwkJKH4oUEFHRV9TSVpFLTEpKQotLSAKMi4zNy4xCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
