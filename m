Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B18C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:20:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06AB94B104;
	Thu, 27 Jan 2022 11:20:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vggP42BTDPep; Thu, 27 Jan 2022 11:20:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD2F14B08A;
	Thu, 27 Jan 2022 11:20:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAA3749F56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OYeoPlQWFfB9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:20:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4547949F1F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4399113E;
 Thu, 27 Jan 2022 08:20:27 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 660703F766;
 Thu, 27 Jan 2022 08:20:25 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v2 kvmtool 01/10] linux/err.h: Add missing stdbool.h include
Date: Thu, 27 Jan 2022 16:20:24 +0000
Message-Id: <20220127162033.54290-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127162033.54290-1-alexandru.elisei@arm.com>
References: <20220127162033.54290-1-alexandru.elisei@arm.com>
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

QWRkIG1pc3NpbmcgaGVhZGVyIHN0ZGJvb2wuaCB0byBhdm9pZCBlcnJvcnMgbGlrZSB0aGlzIG9u
ZSwgd2hpY2ggY2FuCmhhcHBlbiBpZiB0aGUgaW5jbHVkaW5nIGZpbGUgZG9lc24ndCBpbmNsdWRl
IHN0ZGJvb2wuaDoKCmluY2x1ZGUvbGludXgvZXJyLmg6MzM6MTU6IGVycm9yOiB0eXBlIGRlZmF1
bHRzIHRvIOKAmGludOKAmSBpbiBkZWNsYXJhdGlvbiBvZiDigJhib29s4oCZIFstV2Vycm9yPWlt
cGxpY2l0LWludF0KICAgMzMgfCBzdGF0aWMgaW5saW5lIGJvb2wgX19tdXN0X2NoZWNrIElTX0VS
UihfX2ZvcmNlIGNvbnN0IHZvaWQgKnB0cikKICAgICAgfCAgICAgICAgICAgICAgIF5+fn4KaW5j
bHVkZS9saW51eC9lcnIuaDozMzoxNTogZXJyb3I6IHZhcmlhYmxlIOKAmGJvb2zigJkgZGVjbGFy
ZWQg4oCYaW5saW5l4oCZIFstV2Vycm9yXQppbmNsdWRlL2xpbnV4L2Vyci5oOjMzOjE6IGVycm9y
OiDigJh3YXJuX3VudXNlZF9yZXN1bHTigJkgYXR0cmlidXRlIG9ubHkgYXBwbGllcyB0byBmdW5j
dGlvbiB0eXBlcyBbLVdlcnJvcj1hdHRyaWJ1dGVzXQogICAzMyB8IHN0YXRpYyBpbmxpbmUgYm9v
bCBfX211c3RfY2hlY2sgSVNfRVJSKF9fZm9yY2UgY29uc3Qgdm9pZCAqcHRyKQogICAgICB8IF5+
fn5+fgppbmNsdWRlL2xpbnV4L2Vyci5oOjMzOjMzOiBlcnJvcjogZXhwZWN0ZWQg4oCYLOKAmSBv
ciDigJg74oCZIGJlZm9yZSDigJhJU19FUlLigJkKICAgMzMgfCBzdGF0aWMgaW5saW5lIGJvb2wg
X19tdXN0X2NoZWNrIElTX0VSUihfX2ZvcmNlIGNvbnN0IHZvaWQgKnB0cikKICAgICAgfCAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fgppbmNsdWRlL2xpbnV4L2Vyci5oOjM4
OjE1OiBlcnJvcjogdHlwZSBkZWZhdWx0cyB0byDigJhpbnTigJkgaW4gZGVjbGFyYXRpb24gb2Yg
4oCYYm9vbOKAmSBbLVdlcnJvcj1pbXBsaWNpdC1pbnRdCiAgIDM4IHwgc3RhdGljIGlubGluZSBi
b29sIF9fbXVzdF9jaGVjayBJU19FUlJfT1JfTlVMTChfX2ZvcmNlIGNvbnN0IHZvaWQgKnB0cikK
ICAgICAgfCAgICAgICAgICAgICAgIF5+fn4KaW5jbHVkZS9saW51eC9lcnIuaDozODoxNTogZXJy
b3I6IHZhcmlhYmxlIOKAmGJvb2zigJkgZGVjbGFyZWQg4oCYaW5saW5l4oCZIFstV2Vycm9yXQpp
bmNsdWRlL2xpbnV4L2Vyci5oOjM4OjE6IGVycm9yOiDigJh3YXJuX3VudXNlZF9yZXN1bHTigJkg
YXR0cmlidXRlIG9ubHkgYXBwbGllcyB0byBmdW5jdGlvbiB0eXBlcyBbLVdlcnJvcj1hdHRyaWJ1
dGVzXQogICAzOCB8IHN0YXRpYyBpbmxpbmUgYm9vbCBfX211c3RfY2hlY2sgSVNfRVJSX09SX05V
TEwoX19mb3JjZSBjb25zdCB2b2lkICpwdHIpCiAgICAgIHwgXn5+fn5+CmluY2x1ZGUvbGludXgv
ZXJyLmg6Mzg6MTU6IGVycm9yOiByZWR1bmRhbnQgcmVkZWNsYXJhdGlvbiBvZiDigJhib29s4oCZ
IFstV2Vycm9yPXJlZHVuZGFudC1kZWNsc10KICAgMzggfCBzdGF0aWMgaW5saW5lIGJvb2wgX19t
dXN0X2NoZWNrIElTX0VSUl9PUl9OVUxMKF9fZm9yY2UgY29uc3Qgdm9pZCAqcHRyKQogICAgICB8
ICAgICAgICAgICAgICAgXn5+fgppbmNsdWRlL2xpbnV4L2Vyci5oOjMzOjE1OiBub3RlOiBwcmV2
aW91cyBkZWNsYXJhdGlvbiBvZiDigJhib29s4oCZIHdhcyBoZXJlCiAgIDMzIHwgc3RhdGljIGlu
bGluZSBib29sIF9fbXVzdF9jaGVjayBJU19FUlIoX19mb3JjZSBjb25zdCB2b2lkICpwdHIpCiAg
ICAgIHwgICAgICAgICAgICAgICBefn5+CmluY2x1ZGUvbGludXgvZXJyLmg6Mzg6MzM6IGVycm9y
OiBleHBlY3RlZCDigJgs4oCZIG9yIOKAmDvigJkgYmVmb3JlIOKAmElTX0VSUl9PUl9OVUxM4oCZ
CiAgIDM4IHwgc3RhdGljIGlubGluZSBib29sIF9fbXVzdF9jaGVjayBJU19FUlJfT1JfTlVMTChf
X2ZvcmNlIGNvbnN0IHZvaWQgKnB0cikKICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIF5+fn5+fn5+fn5+fn5+CmluY2x1ZGUvbGludXgvZXJyLmg6IEluIGZ1bmN0aW9uIOKA
mFBUUl9FUlJfT1JfWkVST+KAmToKaW5jbHVkZS9saW51eC9lcnIuaDo1ODo2OiBlcnJvcjogaW1w
bGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24g4oCYSVNfRVJS4oCZIFstV2Vycm9yPWltcGxp
Y2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQogICA1OCB8ICBpZiAoSVNfRVJSKHB0cikpCiAgICAg
IHwgICAgICBefn5+fn4KaW5jbHVkZS9saW51eC9lcnIuaDo1ODo2OiBlcnJvcjogbmVzdGVkIGV4
dGVybiBkZWNsYXJhdGlvbiBvZiDigJhJU19FUlLigJkgWy1XZXJyb3I9bmVzdGVkLWV4dGVybnNd
CgpTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4YW5kcnUuZWxpc2VpQGFybS5j
b20+Ci0tLQogaW5jbHVkZS9saW51eC9lcnIuaCB8IDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Vyci5oIGIvaW5jbHVkZS9s
aW51eC9lcnIuaAppbmRleCBhNzI5MTIwNjQ0ZDUuLjEyNTZjN2FiZmVmYSAxMDA2NDQKLS0tIGEv
aW5jbHVkZS9saW51eC9lcnIuaAorKysgYi9pbmNsdWRlL2xpbnV4L2Vyci5oCkBAIC0xLDYgKzEs
OCBAQAogI2lmbmRlZiBfTElOVVhfRVJSX0gKICNkZWZpbmUgX0xJTlVYX0VSUl9ICiAKKyNpbmNs
dWRlIDxzdGRib29sLmg+CisKICNpbmNsdWRlIDxsaW51eC9jb21waWxlci5oPgogI2luY2x1ZGUg
PGxpbnV4L3R5cGVzLmg+CiAKLS0gCjIuMzEuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
