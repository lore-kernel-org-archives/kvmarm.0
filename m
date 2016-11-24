From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v7 04/11] libcflat: add PRI(dux)32 format types
Date: Thu, 24 Nov 2016 16:10:26 +0000
Message-ID: <20161124161033.11456-5-alex.bennee@linaro.org>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161124161033.11456-1-alex.bennee@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: mttcg@listserver.greensocs.com, peter.maydell@linaro.org, claudio.fontana@huawei.com, nikunj@linux.vnet.ibm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, a.rigo@virtualopensystems.com, qemu-devel@nongnu.org, cota@braap.org, serge.fdrv@gmail.com, pbonzini@redhat.com, bobby.prani@gmail.com, rth@twiddle.net, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, fred.konrad@greensocs.com
List-Id: kvmarm@lists.cs.columbia.edu

U28gd2UgY2FuIGhhdmUgcG9ydGFibGUgZm9ybWF0dGluZyBvZiB1aW50MzJfdCB0eXBlcy4KClNp
Z25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KLS0tCiBs
aWIvbGliY2ZsYXQuaCB8IDUgKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykK
CmRpZmYgLS1naXQgYS9saWIvbGliY2ZsYXQuaCBiL2xpYi9saWJjZmxhdC5oCmluZGV4IGJkY2M1
NjEuLjZkYWI1YmUgMTAwNjQ0Ci0tLSBhL2xpYi9saWJjZmxhdC5oCisrKyBiL2xpYi9saWJjZmxh
dC5oCkBAIC01NSwxMiArNTUsMTcgQEAgdHlwZWRlZiBfQm9vbAkJYm9vbDsKICNkZWZpbmUgdHJ1
ZSAgMQogCiAjaWYgX19TSVpFT0ZfTE9OR19fID09IDgKKyMgIGRlZmluZSBfX1BSSTMyX1BSRUZJ
WAogIyAgZGVmaW5lIF9fUFJJNjRfUFJFRklYCSJsIgogIyAgZGVmaW5lIF9fUFJJUFRSX1BSRUZJ
WAkibCIKICNlbHNlCisjICBkZWZpbmUgX19QUkkzMl9QUkVGSVggICAgICAgICJsIgogIyAgZGVm
aW5lIF9fUFJJNjRfUFJFRklYCSJsbCIKICMgIGRlZmluZSBfX1BSSVBUUl9QUkVGSVgKICNlbmRp
ZgorI2RlZmluZSBQUklkMzIgIF9fUFJJMzJfUFJFRklYCSJkIgorI2RlZmluZSBQUkl1MzIgIF9f
UFJJMzJfUFJFRklYCSJ1IgorI2RlZmluZSBQUkl4MzIgIF9fUFJJMzJfUFJFRklYCSJ4IgogI2Rl
ZmluZSBQUklkNjQgIF9fUFJJNjRfUFJFRklYCSJkIgogI2RlZmluZSBQUkl1NjQgIF9fUFJJNjRf
UFJFRklYCSJ1IgogI2RlZmluZSBQUkl4NjQgIF9fUFJJNjRfUFJFRklYCSJ4IgotLSAKMi4xMC4x
CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgt
YXJtLWtlcm5lbCBtYWlsaW5nIGxpc3QKbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQu
b3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJt
LWtlcm5lbAo=
