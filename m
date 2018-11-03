From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH -next v2 1/3] mm: treewide: remove unused address argument
 from pte_alloc functions
Date: Sat, 3 Nov 2018 13:51:20 +0100
Message-ID: <fd939e7c-3d9e-760e-f20c-e7263f064153@users.sourceforge.net>
References: <20181103040041.7085-1-joelaf@google.com>
 <20181103040041.7085-2-joelaf@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181103040041.7085-2-joelaf@google.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Joel Fernandes <joel@joelfernandes.org>, kernel-janitors@vger.kernel.org
Cc: linux-mips@linux-mips.org, Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Lokesh Gidra <lokeshgidra@google.com>, sparclinux@vger.kernel.org, linux-riscv@lists.infradead.org, Anton Ivanov <anton.ivanov@kot-begemot.co.uk>, Jonas Bonn <jonas@southpole.se>, linux-s390@vger.kernel.org, Daniel Colascione <dancol@google.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-hexagon@vger.kernel.org, Helge Deller <deller@gmx.de>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Hugh Dickins <hughd@google.com>, "James E. J. Bottomley" <jejb@parisc-linux.org>, kasan-dev@googlegroups.com, kvmarm@lists.cs.columb
List-Id: kvmarm@lists.cs.columbia.edu

PiDigKYgVGhlcmUgaXMgY29uY2VybiB0aGF0IOKApgoKRG9lcyB0aGlzIHdvcmRpbmcgbmVlZCBh
IHNtYWxsIGFkanVzdG1lbnQ/CgoKPiBUaGUgY2hhbmdlcyB3ZXJlIG9idGFpbmVkIGJ5IGFwcGx5
aW5nIHRoZSBmb2xsb3dpbmcgQ29jY2luZWxsZSBzY3JpcHQuCgpJIHdvdWxkIGZpbmQgaXQgbmlj
ZXIgaWYgcHJldmlvdXMgcGF0Y2ggcmV2aWV3IGNvbW1lbnRzIHdpbGwgdHJpZ2dlcgpmdXJ0aGVy
IHVzZWZ1bCBlZmZlY3RzIGhlcmUuCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gv
MTA2Mzc3MDMvIzIyMjY1MjAzCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4cHBjLWRldi8w
M2I1MjRmMy01ZjNhLWJhYTAtMjI1NC05YzU4ODEwM2QyZDZAdXNlcnMuc291cmNlZm9yZ2UubmV0
LwpodHRwczovL3d3dy5tYWlsLWFyY2hpdmUuY29tL2xpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMu
b3JnL21zZzE0MDAwOS5odG1sCgoKSWYgeW91IGhhdmUgZ290IGRpZmZpY3VsdGllcyB3aXRoIHRo
ZSB1c2FnZSBvZiBhZHZhbmNlZCByZWd1bGFyIGV4cHJlc3Npb25zCmZvciBTbVBMIGNvbnN0cmFp
bnRzLCBJIHN1Z2dlc3QgdG8gdXNlIGRlc2lyZWQgZnVuY3Rpb24gbmFtZXMgaW4gU21QTCBsaXN0
cwpvciBkaXNqdW5jdGlvbnMgaW5zdGVhZCBiZWNhdXNlIG9mIGRpZmZlcmVudCBydW4gdGltZSBj
aGFyYWN0ZXJpc3RpY3MKZm9yIHN1Y2ggYSBzb3VyY2UgY29kZSB0cmFuc2Zvcm1hdGlvbiBhcHBy
b2FjaC4KCgo+IC8vIE5vdGU6IEkgc3BsaXQgdGhlICdpZGVudGlmaWVyIGZuJyBsaW5lLCBzbyBp
ZiB5b3UgYXJlIG1hbnVhbGx5Cj4gLy8gcnVubmluZyBpdCwgcGxlYXNlIHVuc3BsaXQgaXQgc28g
aXQgcnVucyBmb3IgeW91LgoKUGxlYXNlIGRlbGV0ZSB0aGlzIHF1ZXN0aW9uYWJsZSBjb21tZW50
LgoKKiBUaGUgc2VtYW50aWMgcGF0Y2ggbGFuZ3VhZ2Ugc2hvdWxkIGhhbmRsZSB0aGUgbWVudGlv
bmVkIGNvZGUgZm9ybWF0dGluZy4KKiBZb3UgY2FuIHVzZSBtdWx0aS1saW5lIHJlZ3VsYXIgZXhw
cmVzc2lvbnMgKGlmIGl0IHdvdWxkIGJlIGRlc2lyZWQpLgoKCj4gQHB0ZV9hbGxvY19mdW5jX2Rl
ZiBkZXBlbmRzIG9uIHBhdGNoIGV4aXN0c0AKPiBpZGVudGlmaWVyIEUyOwo+IGlkZW50aWZpZXIg
Zm4gPX4KCkhvdyBkbyB5b3UgdGhpbmsgYWJvdXQgdG8gYXZvaWQgdGhlIHJlcGV0aXRpb24gb2Yg
YSBTbVBMIGtleSB3b3JkIGF0IHN1Y2ggcGxhY2VzPwoKUmVnYXJkcywKTWFya3VzCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1zbnBzLWFyYyBt
YWlsaW5nIGxpc3QKbGludXgtc25wcy1hcmNAbGlzdHMuaW5mcmFkZWFkLm9yZwpodHRwOi8vbGlz
dHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LXNucHMtYXJj
