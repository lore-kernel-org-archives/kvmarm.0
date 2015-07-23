From: harry <13401187209@126.com>
Subject: KVM on ARM: Problems on the implementation of a print function in
 HYP mode
Date: Thu, 23 Jul 2015 14:56:10 +0800 (CST)
Message-ID: <4df8b380.7db2.14eb9b2a977.Coremail.13401187209@126.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7148447299160646185=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0AA258F93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2015 02:44:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vHQn2saw90zc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jul 2015 02:44:02 -0400 (EDT)
Received: from m15-30.126.com (m15-30.126.com [220.181.15.30])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C96E58F92
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2015 02:44:01 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============7148447299160646185==
Content-Type: multipart/alternative;
	boundary="----=_Part_125115_725074292.1437634570614"

------=_Part_125115_725074292.1437634570614
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

SSB3YW50IHRvIGltcGxlbWVudCBhIHByaW50IGZ1bmN0aW9uIGluIEhZUCBtb2RlIHRvIGxldCB0
aGUgVk1NIHRvIHByaW50IHNvbWUgaW5mb3JtYXRpb24uCgoKTm93IEkga25vdyB0aGVyZSBhcmUg
b25seSBzb21lIGFzbSBjb2RlIGluIEhZUCBtb2RlLiBTbyBpZiBJIHdhbnQgdG8gbW92ZSBhbGwg
cHJpbnQgZnVuY2l0b24gY29kZSBpbnRvIEhZUCBtb2RlIG1heSBiZSBjb21wbGV4LiAKCgpPdGhl
cnMgYWR2aXNlIG1lIHRoYXQgSSBjYW4gY3JlYXRlIGFuIHVwY2FsbCBtZWNoYW5pc20gdG8gY2Fs
bCBwcmludCBmdW5jdGlvbiBpbiBrZXJuZWwuIEJ1dCBJIGhhdmUgbm8gaWRlYS4KCgpNYXkgYW55
Ym9keSBnaXZlIG1lIHNvbWUgYWR2aXNlcyBhYm91dCB0aGUgdXBjYWxsIG1lY2hhbmlzbT8gT3Ig
aWYgS1ZNIGhhcyB0aGlzIGtpbmQgb2YgbWVjaGFuaXNtIGFscmVhZHk/CgoKVGhhbmsgeW91IHZl
cnkgbXVjaC4KCgpIYXJyeS4=
------=_Part_125115_725074292.1437634570614
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: base64

PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS43O2NvbG9yOiMwMDAwMDA7Zm9udC1zaXplOjE0cHg7
Zm9udC1mYW1pbHk6QXJpYWwiPjxkaXY+SSB3YW50IHRvIGltcGxlbWVudCBhIHByaW50IGZ1bmN0
aW9uIGluIEhZUCBtb2RlIHRvIGxldCB0aGUgVk1NIHRvIHByaW50IHNvbWUgaW5mb3JtYXRpb24u
PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5Ob3cgSSBrbm93IHRoZXJlIGFyZSBvbmx5IHNvbWUg
YXNtIGNvZGUgaW4gSFlQIG1vZGUuIFNvIGlmIEkgd2FudCB0byBtb3ZlIGFsbCBwcmludCBmdW5j
aXRvbiBjb2RlIGludG8gSFlQIG1vZGUgbWF5IGJlIGNvbXBsZXguJm5ic3A7PC9kaXY+PGRpdj48
YnI+PC9kaXY+PGRpdj5PdGhlcnMgYWR2aXNlIG1lIHRoYXQgSSBjYW4gY3JlYXRlIGFuIHVwY2Fs
bCBtZWNoYW5pc20gdG8gY2FsbCBwcmludCBmdW5jdGlvbiBpbiBrZXJuZWwuIEJ1dCBJIGhhdmUg
bm8gaWRlYS48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2Pk1heSBhbnlib2R5IGdpdmUgbWUgc29t
ZSBhZHZpc2VzIGFib3V0IHRoZSB1cGNhbGwgbWVjaGFuaXNtPyBPciBpZiBLVk0gaGFzIHRoaXMg
a2luZCBvZiBtZWNoYW5pc20gYWxyZWFkeT88L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PlRoYW5r
IHlvdSB2ZXJ5IG11Y2guPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5IYXJyeS48L2Rpdj48L2Rp
dj48YnI+PGJyPjxzcGFuIHRpdGxlPSJuZXRlYXNlZm9vdGVyIj48c3BhbiBpZD0ibmV0ZWFzZV9t
YWlsX2Zvb3RlciI+PGRpdiBpZD0ibmV0ZWFzZV9tYWlsX2Zvb3RlciI+PGRpdiBzdHlsZT0iYm9y
ZGVyLXRvcDojQ0NDQ0NDIDFweCBzb2xpZDtwYWRkaW5nOjEwcHggNXB4O2ZvbnQtc2l6ZToxMnB4
O2NvbG9yOiM3Nzc3Nzc7bGluZS1oZWlnaHQ6MjJweCI+wLTX1CA8YiBzdHlsZT0iY29sb3I6I0ND
MzMwMCI+zfjS1zwvYj48YiBzdHlsZT0iY29sb3I6IzMzMzMzMyI+yta7+rrFwuvTys/kPC9iPiAt
LSDT0MrWu/q+zdPQzfjS18rWu/q6xcLr08rP5KOsPGEgaWQ9Im1vYmlsZV9zZXQiIHN5cz0iMSIg
bG9nPTEgbG9naWQ9ImZyZWVfc21zXzIwMTIwNTA0IiBocmVmPSJodHRwOi8vc2hvdWppLjE2My5j
b20iIHRhcmdldD0iX2JsYW5rIiBzdHlsZT0iY29sb3I6IzMzNjZGRjt0ZXh0LWRlY29yYXRpb246
bm9uZSI+wcu94s/qx+kmZ3Q7PC9hPjwvZGl2PjwvZGl2Pgo8L3NwYW4+PC9zcGFuPg==
------=_Part_125115_725074292.1437634570614--


--===============7148447299160646185==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7148447299160646185==--
