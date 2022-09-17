Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9D0C54EE9
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 21:58:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2356D4B7E2;
	Sat, 17 Sep 2022 17:58:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qhTS-6j2aHCu; Sat, 17 Sep 2022 17:58:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 787254B7C2;
	Sat, 17 Sep 2022 17:58:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9313B40DAE
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 17:58:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gj9oSW7tzoRQ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Sep 2022 17:58:35 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B6F140D23
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 17:58:35 -0400 (EDT)
Date: Sat, 17 Sep 2022 21:58:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663451913;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QUp4s6kylqCS1H/Wwh67THvWSkQ9J4fPMiM8DGd2CMU=;
 b=kSvZF+wyXB4j5CEkEMnUcYygpmU0FUKxkZuYviVAby65ZmStqnwNe3yyeB9jkwSyOVYytK
 onFI1ZdlVuEK0AaRX8CQo0+iuizzTE6eaRy1BuhG1S79vn1UHXE7FE8ht9H5Dje+VB/X1G
 JBNMS5cfjSIAqzA+9c5Nergx9qdmM2w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YyZDBIQsux1g97zl@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-10-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, maz@kernel.org,
 bgardon@google.com, pbonzini@redhat.com, axelrasmussen@google.com,
 kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

T24gVHVlLCBTZXAgMDYsIDIwMjIgYXQgMDY6MDk6MjZQTSArMDAwMCwgUmljYXJkbyBLb2xsZXIg
d3JvdGU6Cj4gQWRkIGEgbmV3IHRlc3QgZm9yIHN0YWdlIDIgZmF1bHRzIHdoZW4gdXNpbmcgZGlm
ZmVyZW50IGNvbWJpbmF0aW9ucyBvZgo+IGd1ZXN0IGFjY2Vzc2VzIChlLmcuLCB3cml0ZSwgUzFQ
VFcpLCBiYWNraW5nIHNvdXJjZSB0eXBlIChlLmcuLCBhbm9uKQo+IGFuZCB0eXBlcyBvZiBmYXVs
dHMgKGUuZy4sIHJlYWQgb24gaHVnZXRsYmZzIHdpdGggYSBob2xlKS4gVGhlIG5leHQKPiBjb21t
aXRzIHdpbGwgYWRkIGRpZmZlcmVudCBoYW5kbGluZyBtZXRob2RzIGFuZCBtb3JlIGZhdWx0cyAo
ZS5nLiwgdWZmZAo+IGFuZCBkaXJ0eSBsb2dnaW5nKS4gVGhpcyBmaXJzdCBjb21taXQgc3RhcnRz
IGJ5IGFkZGluZyB0d28gc2FuaXR5IGNoZWNrcwo+IGZvciBhbGwgdHlwZXMgb2YgYWNjZXNzZXM6
IEFGIHNldHRpbmcgYnkgdGhlIGh3LCBhbmQgYWNjZXNzaW5nIG1lbXNsb3RzCj4gd2l0aCBob2xl
cy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBSaWNhcmRvIEtvbGxlciA8cmljYXJrb2xAZ29vZ2xlLmNv
bT4KCkhleSBSaWNhcmRvLAoKWW91J2xsIG5lZWQgdG8gdXBkYXRlIC5naXRpZ25vcmUgZm9yIHRo
aXMgcGF0Y2guIEFkZGl0aW9uYWxseSwgYnVpbGRpbmcKdGhpcyB0ZXN0IHRocm93cyB0aGUgZm9s
bG93aW5nIGNvbXBpbGVyIHdhcm5pbmc6CgpJbiBmdW5jdGlvbiDigJhsb2FkX2V4ZWNfY29kZV9m
b3JfdGVzdOKAmSwKICAgIGlubGluZWQgZnJvbSDigJhydW5fdGVzdOKAmSBhdCBhYXJjaDY0L3Bh
Z2VfZmF1bHRfdGVzdC5jOjc0NToyOgphYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdC5jOjU0NTo5OiB3
YXJuaW5nOiBhcnJheSBzdWJzY3JpcHQg4oCYbG9uZyB1bnNpZ25lZCBpbnRbMF3igJkgaXMgcGFy
dGx5IG91dHNpZGUgYXJyYXkgYm91bmRzIG9mIOKAmHVuc2lnbmVkIGNoYXJbMV3igJkgWy1XYXJy
YXktYm91bmRzXQogIDU0NSB8ICAgICAgICAgbWVtY3B5KGNvZGUsIGMsIDgpOwogICAgICB8ICAg
ICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+CgpJJ3ZlIGZpeGVkIGJvdGggb2YgdGhlc2UgaW4gdGhl
IGFwcGVuZGVkIGRpZmYsIGZlZWwgZnJlZSB0byBzcXVhc2guCgotLQpUaGFua3MsCk9saXZlcgoK
RnJvbSAwYTVkMzcxMGI5MDQzYWU4ZmU1YTlkN2NjNDhlYjg1NGQxYjdiNzQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgVXB0b24gPG9saXZlci51cHRvbkBsaW51eC5kZXY+
CkRhdGU6IFNhdCwgMTcgU2VwIDIwMjIgMjE6Mzg6MTEgKzAwMDAKU3ViamVjdDogW1BBVENIXSBm
aXh1cCEgS1ZNOiBzZWxmdGVzdHM6IGFhcmNoNjQ6IEFkZCBhYXJjaDY0L3BhZ2VfZmF1bHRfdGVz
dAoKLS0tCiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vLmdpdGlnbm9yZSAgICAgICAgICAg
ICAgIHwgIDEgKwogLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1bHRf
dGVzdC5jICB8IDEyICsrKy0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
a3ZtLy5naXRpZ25vcmUgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vLmdpdGlnbm9yZQpp
bmRleCBkNjI1YTNmODM3ODAuLjdhOTAyMmNmYTAzMyAxMDA2NDQKLS0tIGEvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMva3ZtLy5naXRpZ25vcmUKKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
a3ZtLy5naXRpZ25vcmUKQEAgLTMsNiArMyw3IEBACiAvYWFyY2g2NC9kZWJ1Zy1leGNlcHRpb25z
CiAvYWFyY2g2NC9nZXQtcmVnLWxpc3QKIC9hYXJjaDY0L2h5cGVyY2FsbHMKKy9hYXJjaDY0L3Bh
Z2VfZmF1bHRfdGVzdAogL2FhcmNoNjQvcHNjaV90ZXN0CiAvYWFyY2g2NC92Y3B1X3dpZHRoX2Nv
bmZpZwogL2FhcmNoNjQvdmdpY19pbml0CmRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9rdm0vYWFyY2g2NC9wYWdlX2ZhdWx0X3Rlc3QuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdC5jCmluZGV4IDYwYTZhOGE0NWZhNC4uNWVm
MmE3Yjk0MWVjIDEwMDY0NAotLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYWFyY2g2
NC9wYWdlX2ZhdWx0X3Rlc3QuYworKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYWFy
Y2g2NC9wYWdlX2ZhdWx0X3Rlc3QuYwpAQCAtNTEyLDcgKzUxMiw3IEBAIHZvaWQgZmFpbF92Y3B1
X3J1bl9tbWlvX25vX3N5bmRyb21lX2hhbmRsZXIoaW50IHJldCkKIAlldmVudHMuZmFpbF92Y3B1
X3J1bnMgKz0gMTsKIH0KIAotZXh0ZXJuIHVuc2lnbmVkIGNoYXIgX19leGVjX3Rlc3Q7CitleHRl
cm4gdWludDY0X3QgX19leGVjX3Rlc3Q7CiAKIHZvaWQgbm9pbmxpbmUgX19yZXR1cm5fMHg3Nyh2
b2lkKQogewpAQCAtNTI2LDcgKzUyNiw3IEBAIHZvaWQgbm9pbmxpbmUgX19yZXR1cm5fMHg3Nyh2
b2lkKQogICovCiBzdGF0aWMgdm9pZCBsb2FkX2V4ZWNfY29kZV9mb3JfdGVzdChzdHJ1Y3Qga3Zt
X3ZtICp2bSkKIHsKLQl1aW50NjRfdCAqY29kZSwgKmM7CisJdWludDY0X3QgKmNvZGU7CiAJc3Ry
dWN0IHVzZXJzcGFjZV9tZW1fcmVnaW9uICpyZWdpb247CiAJdm9pZCAqaHZhOwogCkBAIC01MzYs
MTMgKzUzNiw3IEBAIHN0YXRpYyB2b2lkIGxvYWRfZXhlY19jb2RlX2Zvcl90ZXN0KHN0cnVjdCBr
dm1fdm0gKnZtKQogCWFzc2VydChURVNUX0VYRUNfR1ZBIC0gVEVTVF9HVkEpOwogCWNvZGUgPSBo
dmEgKyA4OwogCi0JLyoKLQkgKiBXZSBuZWVkIHRoZSBjYXN0IHRvIGJlIHNlcGFyYXRlIGluIG9y
ZGVyIGZvciB0aGUgY29tcGlsZXIgdG8gbm90Ci0JICogY29tcGxhaW4gd2l0aDogIuKAmG1lbWNw
eeKAmSBmb3JtaW5nIG9mZnNldCBbMSwgN10gaXMgb3V0IG9mIHRoZSBib3VuZHMKLQkgKiBbMCwg
MV0gb2Ygb2JqZWN0IOKAmF9fZXhlY190ZXN04oCZIHdpdGggdHlwZSDigJh1bnNpZ25lZCBjaGFy
4oCZIgotCSAqLwotCWMgPSAodWludDY0X3QgKikmX19leGVjX3Rlc3Q7Ci0JbWVtY3B5KGNvZGUs
IGMsIDgpOworCSpjb2RlID0gX19leGVjX3Rlc3Q7CiB9CiAKIHN0YXRpYyB2b2lkIHNldHVwX2Fi
b3J0X2hhbmRsZXJzKHN0cnVjdCBrdm1fdm0gKnZtLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCi0t
IAoyLjM3LjMuOTY4LmdhNmI0YjA4MGU0LWdvb2cKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
